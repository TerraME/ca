
-- @example Parasit model from Hassell et al. (1991).
-- Spatial structure and chaos in insect population
-- dynamics. Nature, Lond. 353, 255-258.

import("ca")

Parasit = CellularAutomataModel{
	finalTime = 500,
	dim = 50,
	neighborhood = "vonneumann",
	init = function(cell)
		cell.state = Random():integer(0, 8)
	end,	
	changes = function(cell)
		    if cell.past.state == 0 and countNeighbors(cell, 1) > 0 then cell.state = 1
		elseif cell.past.state == 1 then cell.state = 2
		elseif cell.past.state == 2 then cell.state = 3
		elseif cell.past.state == 3 and countNeighbors(cell, 5) > 0 then cell.state = 4
		elseif cell.past.state == 4 then cell.state = 5
		elseif cell.past.state == 5 then cell.state = 6
		elseif cell.past.state == 6 then cell.state = 7
		elseif cell.past.state == 7 then cell.state = 8
		elseif cell.past.state == 8 then cell.state = 0 end
	end,
	map = {
		select = "state",
		min = 0,
		max = 8,
		slices = 9,
		color = "Blues"
	}
}

Parasit:execute()

