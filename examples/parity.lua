
-- @example Parity model, by Nigel Gilbert. See 
-- modelingcommons.org/browse/one_model/3381.
-- @image parity.bmp

import("ca")

Parity = CellularAutomataModel{
	finalTime = 500,
	dim = 50,
	neighborhood = "vonneumann",
	init = function(cell)
		if (cell.x == 10 and cell.y == 25) or (cell.x == 40 and cell.y == 25) then
			cell.state = "on"
		else
			cell.state = "off"
		end
	end,	
	changes = function(cell)
		local count = countNeighbors(cell, "on")

		if count == 1 or count == 3 then
			cell.state = "on"
		else
			cell.state = "off"
		end
	end,
	map = {
		select = "state",
		value = {"on", "off"},
		color = {"black", "white"}
	}
}

Parity:execute()

