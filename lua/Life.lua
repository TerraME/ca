
local function countNeighbors(cell, val)
	local count = 0
	forEachNeighbor(cell, function(cell, neigh)
		if neigh.past.state == val then
			count = count + 1
		end
	end)
	return count
end

--- A Model to simulate Game of Life.
-- Look at the "oscillators" and the "spaceships"
-- in http://www.conwaylife.com/wiki/Main_Page for the 
-- description some patterns.
-- @arg data.finalTime A number with the final time of the simulation.
-- @arg data.dim A number with the x and y size of space.
-- @arg data.pattern A set of available patterns to be used as
-- initial state for the cellular automata.
-- The available patterns are "random", "rabbits", "heavySpaceship",
-- "dinnerTable", "rpentomino", "pentaDecathlon", "octagon",
-- "figureEight", "pulsar", "glider", "brianOsc". The default is
-- random, with half alive cells randomly distributed in space.
Life = CellularAutomataModel{
	finalTime = 100,
	dim = 30,
	pattern = Choice{
		"random",
		"rabbits",
		"heavySpaceship",
		"dinnerTable",
		"rpentomino",
		"pentaDecathlon",
		"octagon",
		"figureEight",
		"pulsar",
		"glider",
		"brianOsc",
	},
	space = function(model)
		local cell

		if model.pattern ~= "random" then
			cell = Cell{
				init = function(cell)
					cell.state = "dead"
				end
			}
		else
			cell = Cell{
				init = function(cell)
					if Random():number() > 0.5 then
						cell.state = "alive"
					else
						cell.state = "dead"
					end
				end
			}
		end

		local cs = CellularSpace{
			xdim = model.dim,
			instance = cell
		}

		if model.pattern ~= "random" then
			local pattern = _G[model.pattern]()

			if cs.xdim < pattern.xdim then
				customError("CellularSpace should have dim at least "..pattern.xdim..".")
			elseif cs.ydim < pattern.ydim then
				customError("CellularSpace should have dim at least "..pattern.ydim..".")
			end

			insertPattern(cs, pattern, 0, 0)
		end

		cs:createNeighborhood{wrap = true}

		return cs
	end,
	changes = function(cell)
		local alive = countNeighbors(cell, "alive")
		if alive < 2 then
			cell.state = "dead"
		elseif alive > 3 then
			cell.state = "dead"
		elseif alive == 3 and cell.past.state == "dead" then
			cell.state = "alive"
		end
	end,
	map = {
		select = "state",
		value = {"dead", "alive"},
		color = {"black", "white"}
	}
}

