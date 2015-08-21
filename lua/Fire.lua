
local function countNeighbors(cell, val)
	local count = 0
	forEachNeighbor(cell, function(cell, neigh)
		if neigh.past.state == val then
			count = count + 1
		end
	end)
	return count
end


if false then
	FOREST = "forest"
	EMPTY = "empty"
	BURNING = "burning"
	BURNED = "burned"
else
	FOREST = 1
	EMPTY = 2
	BURNING = 3
	BURNED = 4
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
					cell.state = FOREST
				else
					cell.state = EMPTY
				end
			end
		}

		local cs = CellularSpace{
			xdim = model.dim,
			instance = cell
		}

		cs:sample().state = BURNING
		cs:createNeighborhood{strategy = "vonneumann"}

		cs.burned = function()
			return #Trajectory{target = cs, select = function(cell)
				return cell.state == BURNED
			end}
		end

		Chart{
			target = cs,
			select = "burned"
		}

		return cs
	end,
	changes = function(cell)
		if cell.past.state == BURNING then
			cell.state = BURNED
		elseif cell.past.state == FOREST then
			local burning = countNeighbors(cell, BURNING)
			if burning > 0 then
				cell.state = BURNING
			end
		end
	end,
	map = {
		select = "state",
		value = {FOREST, BURNING, BURNED, EMPTY},
		color = {"green", "red", "brown", "white"}
	}
}

