
local function plotPerfil(model)
	local perfil = {x = {}, state = {}}

	forEachCell(model.cs, function(cell)
		table.insert(perfil.x, cell.x)
		table.insert(perfil.state, cell.state)
	end)

	local perfilMean = {elevation = {}, plantCover = {}}
	local sum
	for i = 0, 49 do
		perfilMean.elevation[i + 1] = i
		sum = 0
		for j = 1, 2500 do
			if perfil.x[j] == i and perfil.state[j] == "plants" then
				sum = sum + 1
			end
		end

		perfilMean.plantCover[i + 1] = sum / 50
	end

	Chart{
		data = perfilMean,
		select = "plantCover",
		xAxis = "elevation",
		yLabel = "Plant Cover",
		xLabel = "Elevation (un)",
		symbol = "square",
	}
end

local function init(model)
	model.cell = Cell{
		state = Random{plants = model.plantCover, empty = 1 - model.plantCover},
		water = 0,
		init = function(cell)
			-- cell elevation is defined based on dimension: equally on x axis and varying on y
			cell.elevation = 50 - cell.y
		end,
		evapotranspiration = function(cell) -- annual loss of water by evapotranspiration
			if cell.state == "plants" then
				cell.water = 10
			else
				cell.water = 0
			end
		end,
		plantSurvival = function(cell)
			if cell.water < model.dryCoeff * model.rainfallPlantSurvival and cell.state == "plants" then
				-- plant cells too dry become empty
				cell.state = "empty"
			elseif cell.water >= model.wetCoeff * model.rainfallPlantSurvival and cell.state == "empty" then
				-- empty cells too wet become plant
				cell.state = "plants"
			end
		end,
		rain = function(cell)
			cell.water = cell.water + model.rainfall
		end,
		waterPartition = function(cell)
			if cell.state == "empty" then -- empty case
				-- all water except 10 mm goes downslope
				forEachNeighbor(cell, function(_, neigh)
					if neigh.elevation < cell.elevation then
						neigh.water = neigh.water + (cell.water - 10)
					end
				end)

				-- 10 mm of water stays in the soil
				cell.water = 10
				return
			end

			-- plant case
			-- calculate 10% of cell water to give to each neighbor
			local tenPercent = cell.water * 0.1
			-- remember first cell
			local donorCell = cell

			-- distribute water downslope
			forEachNeighbor(cell, function(_, neigh)
				if neigh.elevation < cell.elevation then
					-- gives neighbor 10% of cell's water
					neigh.water = neigh.water + tenPercent
					-- remove 10% water from cell
					cell.water = cell.water - tenPercent
				end
			end)

			-- distribute water to neighbors
			if not model.distributeLaterally then return end

			forEachNeighbor(cell, function(_, neigh)
				if neigh.elevation ~= cell.elevation then return end

				neigh.water = neigh.water + tenPercent -- gives neighbor 10% of cell's water
				cell.water = cell.water - tenPercent -- remove 10% water from cell

				if not model.distributeToSecondNeighbors then return end

				forEachNeighbor(neigh, function(c, n)
					-- neighbor elevation same as cell guarantees that neighbor is sharing laterally
					-- neighbor different from donor cell guarantees that model doesnt try to share water from donorcell to itself
					if n.elevation == c.elevation and n ~= donorCell then
						n.water = n.water + tenPercent / 2 -- gives neighbor 5% of donor cell's water
						donorCell.water = donorCell.water - tenPercent / 2 -- remove 10% water from cell
					end
				end)
			end)
		end
	}

	model.cs = CellularSpace{
		xdim = 50,
		instance = model.cell
	}

	model.cs:createNeighborhood{
		strategy = "vonneumann"
	}

	model.traj = Trajectory{
		target = model.cs,
		greater = function(cell1, cell2) return cell1.elevation > cell2.elevation end
	}

	model.map = Map{
		target = model.cs,
		select = "state",
		value = {"plants", "empty"},
		color = {"darkGreen", "lightGray"}
	}

	model.timer = Timer{
		Event{action = model.cs},
		Event{action = function()
				model.cs:rain()
				model.traj:waterPartition()
				model.cs:plantSurvival()
				model.cs:evapotranspiration()
			end},
		Event{action = model.map},
		Event{start = 11, action = function()
			if model.rainDecrease then
				model.rainfall = model.rainfall - 2
				if model.rainfall < 0 then
					model.rainfall = 0
				end
			end
		end},
		Event{start = model.finalTime, priority = "low", action = function()
			plotPerfil(model)

			model.plantCoverFinal = #model.cs:split("state").plants / 2500
			return false
		end}
	}
end

--- Banded vegetation model based on Dunkerley (1997) Banded vegetation: development under uniform
-- rainfall from a simple cellular automaton model. Plant Ecology 129(2):103-111.
-- This model was implemented by Ana Claudia Rorato, Karina Tosto and Ricardo Dal'Agnol da Silva.
-- @arg data.plantCover Initial percentage of plant cover. A number from 0.01 to 1.
-- @arg data.dryCoeff A coefficient beteeen 1.2 and 3.5 to change the state of a cell to dry .
-- @arg data.wetCoeff A coefficient beteeen 0.6 and 1.2 to change the state of a cell to wet.
-- @arg data.rainfallPlantSurvival A value that multiplies dry and wet coefficients. The default value is 100.
-- @arg data.rainfall Amount of rain in each time step. The default value is 100.
-- @arg data.distributeLaterally Distribute water to lateral neighbors? The default value is true.
-- @arg data.distributeToSecondNeighbors Distribute water to the neighbors of lateral neighbors? The default value is true. It only works if distributeLaterally is activated.
-- @arg data.rainDecrease A boolean value indicating whether the rain decreases after time 10. The default value is true.
-- @arg data.finalTime Final simulation tome. The default value is 20.
-- @output plantCoverFinal The percentage of plant cover in the end of the simulation.
-- @image banded-vegetation.bmp
BandedVegetation = Model{
	plantCover = Choice{min = 0.01, max = 1},
	dryCoeff = Choice{min = 1.2, max = 3.5},
	wetCoeff = Choice{min = 0.6, max = 1.2},
	rainfallPlantSurvival = 100,
	rainfall = 100,
	distributeLaterally = true,
	distributeToSecondNeighbors = true,
	rainDecrease = true,
	finalTime = 20,
	init = init
}

