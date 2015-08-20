
local function countNeighbors(cell, val)
	local count = 0
	forEachNeighbor(cell, function(cell, neigh)
		if neigh.past.state == val then
			count = count + 1
		end
	end)
	return count
end

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
		if model.pattern ~= "random" then
			local cell = Cell{
				init = function(cell)
					cell.state = "dead"
				end
			}

			local cs = CellularSpace{
				xdim = model.dim,
				instance = cell
			}

			local pattern = _G[model.pattern]()

			if cs.xdim < pattern.xdim then
				customError("CellularSpace should have dim at least "..pattern.xdim..".")
			elseif cs.ydim < pattern.ydim then
				customError("CellularSpace should have dim at least "..pattern.ydim..".")
			end

			insertPattern(cs, pattern, 0, 0)

			return cs
		else
			local cell = Cell{
				init = function(cell)
					if Random():number() > 0.5 then
						cell.state = "alive"
					else
						cell.state = "dead"
					end
				end
			}

			local cs = CellularSpace{
				xdim = model.dim,
				instance = cell
			}

			return cs
		end
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

