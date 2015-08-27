
-- @example Oscillator model from Ermentrout & Edelstein-Keshet (1993).
-- Cellular Automata Approaches to Biological Modeling.
-- Jornal of Theoretical Biology, 160, 97-133.

import("ca")

local amount = {0, -1, -2, -2, -3, -2, -2, -1, 0, 1, 2, 2, 3, 2, 2, 1}

Oscillator = CellularAutomataModel{
	finalTime = 400,
	dim = 50,
	init = function(cell)
		cell.state = Random():integer(0, 15)
	end,	
	changes = function(cell)
		local count = countNeighbors(cell, 0)

		if count > 0 then
			cell.state = (cell.past.state + amount[cell.past.state + 1] + 1) % 16
		else
			cell.state = (cell.state + 1) % 16
		end
	end,
	map = {
		select = "state",
		min = 0,
		max = 15,
		slices = 16,
		color = "Blues"
	}
}

Oscillator:execute()

