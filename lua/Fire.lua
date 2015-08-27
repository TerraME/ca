
local function countNeighbors(cell, val)
	local count = 0
	forEachNeighbor(cell, function(cell, neigh)
		if neigh.past.state == val then
			count = count + 1
		end
	end)
	return count
end

--- A Model to simulate fire in the forest.
-- @arg data.finalTime A number with the final time of the simulation.
-- @arg data.dim A number with the x and y size of space.
Fire = CellularAutomataModel{
	finalTime = 100,
	empty = Choice{min = 0, max = 1, default = 0.1},
	dim = 60,
	space = function(model)
		local cell = Cell{
			init = function(cell)
				if Random():number() > model.empty then
					cell.state = "forest"
				else
					cell.state = "empty"
				end
			end
		}

		local cs = CellularSpace{
			xdim = model.dim,
			instance = cell
		}

		cs:sample().state = "burning"
		cs:createNeighborhood{strategy = "vonneumann"}

		cs.burned = function()
			return #Trajectory{target = cs, select = function(cell)
				return cell.state == "burned"
			end}
		end

		model.chart = Chart{
			target = cs,
			select = "burned"
		}

		return cs
	end,
	changes = function(cell)
		if cell.past.state == "burning" then
			cell.state = "burned"
		elseif cell.past.state == "forest" then
			local burning = countNeighbors(cell, "burning")
			if burning > 0 then
				cell.state = "burning"
			end
		end
	end,
	map = {
		select = "state",
		value = {"forest", "burning", "burned", "empty"},
		color = {"green", "red", "brown", "white"}
	}
}

