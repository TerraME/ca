
-- @example Simple growth model.

import("ca")

DIM = 100
FINAL = 250
PROB = 0.05

Growth = CellularAutomataModel{
	finalTime = FINAL,
	dim = DIM,
	init = function(cell)
		if cell.x == DIM / 2 and cell.y == DIM / 2 then
			cell.state = "alive"
		else
			cell.state = "empty"
		end
	end,	
	changes = function(cell, ev)
		local count = countNeighbors(cell, "alive")

		if cell.past.state == "empty" and count > 0 and Random():number() < PROB then
			cell.state = "alive"
		end
	end,
	map = {
		select = "state",
		value = {"alive", "empty"},
		color = {"white", "black"}
	}
}

Growth:execute()

