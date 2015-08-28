
-- @example Snow falling from the sky.

import("ca")

DIM = 50
FINAL = 600
PROB = 0.02

Snow = CellularAutomataModel{
	finalTime = FINAL,
	dim = DIM,
	neighborhood = "vonneumann",
	init = function(cell)
		cell.state = "empty"
	end,	
	changes = function(cell, ev)
		if cell.y == 0 then
			if cell.past.state == "empty" and ev:getTime() < FINAL - DIM and Random():number() < PROB then
				cell.state = "snow"
			else
				cell.state = "empty"
			end
		elseif cell.past.state == "snow" and cell.y < DIM - 1 and cell.parent:get(cell.x, cell.y + 1).past.state == "empty" then
			cell.state = "empty"
		elseif cell.parent:get(cell.x, cell.y - 1).past.state == "snow" then
			cell.state = "snow"
		end
	end,
	map = {
		select = "state",
		value = {"snow", "empty"},
		color = {"white", "black"}
	}
}

Snow:execute()

