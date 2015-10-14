
--- A Model to simulate fire in the forest.
-- @arg data.finalTime A number with the final time of the simulation.
-- @arg data.dim A number with the x and y size of space.
-- @arg data.empty The percentage of empty cells in the beginning of the
-- simulation. It must be a value between 0 and 1, with default 0.1.
-- @image fire.bmp
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

		cs.forest = function()
			return #Trajectory{target = cs, select = function(cell)
				return cell.state == "forest"
			end}
		end

		model.chart = Chart{
			target = cs,
			select = {"burned", "forest"}
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

