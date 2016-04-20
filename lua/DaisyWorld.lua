----------------------------------
-- 2D Daisyworld
-- Environmental Modelling
-- Nourhan, Shahin and Aida.
----------------------------------

-- It calculates the probability to reproduce based on the temperature of the soil
local function calculateProbRepro(cell)
	local diff = math.abs(cell.temperature.reproducePerfect - cell.past.SoilHeat)
	return 100 - diff
end

-- A daisy dies because of old age
local killDaisy = function(cell)
	if cell.past.daisy == "black" then -- one daisy dies, one empty space increment
		cell.lifeSpan = 0
		cell.daisy = "empty"
	elseif cell.past.daisy == "white" then
		cell.lifeSpan = 0
		cell.daisy = "empty"
	end
end

-- It calculates the soil heat based on the neigbours, the mean between neighbours mean and itself
local calculateSoilHeat = function(cell)
	local selfHeat = 0

	if cell.past.daisy == "white" then  --increment or decrement temperature depending on the daisy
		selfHeat = cell.past.SoilHeat - cell.past.SoilHeat * cell.albedo.white
	elseif cell.past.daisy == "black"  then 
		selfHeat = cell.past.SoilHeat + cell.past.SoilHeat * cell.albedo.black
	else
		selfHeat = cell.past.SoilHeat
	end

	local neigbourHeat = 0 -- change temperature to make it similar to the neigbours
	local neighbourCount = 0

	forEachNeighbor(cell, function(cell, neigh) 
		neighbourCount = neighbourCount + 1
		neigbourHeat = neigbourHeat + neigh.past.SoilHeat
	end)

	local neigbourHeat = neigbourHeat / neighbourCount -- calculate the mean of the neighbours
	local heat = (selfHeat + neigbourHeat) / 2
	
	heat = math.min(heat, cell.temperature.max) --make heat value inside the valid range
	heat = math.max(heat, cell.temperature.min)

	return heat
end

-- New daisy is born same color as the neigbour, and with age 0
local function bornNewDaisy(cell)
	local blackDaisyCounter = countNeighbors(cell, "black")
	local whiteDaisyCounter = countNeighbors(cell, "white")

	cell.lifeSpan = 0

	if whiteDaisyCounter > blackDaisyCounter then
		cell.daisy = "white"
	elseif whiteDaisyCounter < blackDaisyCounter then
		cell.daisy = "black"
	elseif whiteDaisyCounter > 0 then  -- equal
		if Random():number(0, 1) < 0.5 then
			cell.daisy = "white"
		else
			cell.daisy = "black"
		end 
	end
end

local update = function(cell)
	if cell.past.daisy ~= "empty" then
		cell.lifeSpan = cell.lifeSpan + 1 --incrementing one day in the life of the daisy if it is not empty
	end

	if cell.past.lifeSpan >= cell.maxLifeSpan then  
		cell:killDaisy()
	end

	cell.SoilHeat = cell:calculateSoilHeat()

	if cell.past.daisy == "empty" and cell.past.SoilHeat > cell.temperature.reproduceMin and cell.past.SoilHeat < cell.temperature.reproduceMax then
		local probabilityReproduce = cell:calculateProbRepro()
		if Random():number() * 100 < probabilityReproduce then --new daisy is born
			cell:bornNewDaisy()
		end
	end
end

--- Implementation of a 2D Daisy World model.
-- We have three type of cells: White daisies, Black daisies and soil, with a given albedo for each of them.
-- The cells are placed randomly in the cellular space depending on the given percentage of soil and white daisies, in the remaining there are placed black daisies. Each of them is given with a random initial age, to control the population of daisies, because when they are old (given age) they die.
-- Each cell is also given a random initial value for soil heat between the range of possible values of temperature.
-- Each time step for CA, the temperature will be calculated as follows: Each cell temperature will be calculated according to the daisy albedo and the previous temperature, also the mean neighbours temperature is calculated and this value is used to calculate the mean between the temperature from the cell itself and the mean of the neighbours.
-- If there is an empty cell with a daisy as neighbour, and the conditions for reproduction are fulfilled, a new daisy will be born in the empty cell.
-- The conditions for reproduction are that the daisy's ground has to be inside the range of temperatures, and if it is in the given perfect temperature to reproduce it will have 100 % of chances to reproduce, and less chances the further it is from the perfect temperature. The new born daisy will be the same type as the maximum neighbourhood type (black or white).
-- The daisies will die on a certain (given) age.
-- The first version of this implementation was developed by Nourhan, Shahin and Aida, as final work for Environmental Modeling course in
-- Erasmus Mundus program, Munster University, 2014. It still needs further development.
-- @arg data.proportions A table with two indexes, empty and white, describing the initial proportions of empty and white cells.
-- @arg data.temperature A table with the temperatures: max for maximum temperature, min for minimum temperature, reproduceMin for the minimum
-- temperature that makes the daisies reproductible, reproducePerfect for the temperature daisies will reproduce with a probability of 100%,
-- and reproduceMax for the maximum temperature where daisies can reproduce.
-- @arg data.finalTime The final simulation time.
-- @arg data.lifeSpan How long does a daisy live?
-- @arg data.dim The x and y dimensions of space.
-- @arg data.albedo A table with white and black albedos.
DaisyWorld = Model{
	proportions = {
		empty = Choice{min = 0.1, max = 0.5, default = 0.5},
		white = Choice{min = 0.1, max = 0.45, default = 0.2}
	},
	temperature = {
		min = Choice{min = 0, max = 100},
		max = Choice{max = 100},
		reproduceMin = Choice{min = 0, max = 100},
		reproducePerfect = Choice{min = 0, max = 100, default = 50},
		reproduceMax = Choice{max = 100}
	},
	finalTime = Choice{min = 100, default = 200},
	albedo = {
		white = Choice{min = 0, max = 1, default = 0.2},
		black = Choice{min = 0, max = 1, default = 0.7}  -- 0-1 How much energy hey absorb as heat from sunlight
	},
	lifeSpan = Choice{min = 2, max = 20, step = 1, default = 10}, -- in time stamps
	dim = 10,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				cell.SoilHeat = 50 --rand:number() * 100
				cell.lifeSpan = Random():number(0, 4) -- we give random number to the age at the first moment

				if Random():number() > model.proportions.empty then
					if Random():number() > model.proportions.white then
						cell.daisy = "black"
					else
						cell.daisy = "white"
					end
				else 
					cell.daisy = "empty"
				end
			end,
			execute = update,
			temperature = model.temperature,
			albedo = model.albedo,
			maxLifeSpan = model.lifeSpan,
			bornNewDaisy = bornNewDaisy,
			calculateSoilHeat = calculateSoilHeat,
			killDaisy = killDaisy,
			calculateProbRepro = calculateProbRepro
		}

		model.cs = CellularSpace{
			xdim = model.dim,
			instance = model.cell,
			emptySpace = function(cs)
				local traj = Trajectory{target = cs, select = function(cell) return cell.daisy == "empty" end}
				return #traj
			end,
			whiteDaisy = function(cs)
				local traj = Trajectory{target = cs, select = function(cell) return cell.daisy == "white" end}
				return #traj
			end,
			blackDaisy = function(cs)
				local traj = Trajectory{target = cs, select = function(cell) return cell.daisy == "black" end}
				return #traj
			end
		}

		model.cs:createNeighborhood{
			strategy = "vonneumann"
		}

		model.chart = Chart{
			target = model.cs,
			select = {"blackDaisy", "whiteDaisy", "emptySpace"}, 
			title = "Population x Time",
			yLabel = "#individual"
		}

		model.cs:notify(0)

		model.map1 = Map{
			target = model.cs,
			select = "SoilHeat",
			max = model.temperature.max,
			min = model.temperature.min,
			slices = 6,
			color = "OrRd"
		}

		model.map2 = Map{
			target = model.cs,
			select = "daisy",
			value = {"black", "white", "empty"},
			color = {"black", "white", "green"}
		}

		model.timer = Timer{
			Event{action = model.cs},
			Event{action = model.chart},
			Event{action = model.map1},
			Event{action = model.map2}
		}
	end
}

