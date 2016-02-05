--- Parasit model from Hassell et al. (1991).
-- Spatial structure and chaos in insect population
-- dynamics. Nature, Lond. 353, 255-258.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.finalTime A number with the final time of the simulation.
-- @image parasit.bmp
Parasit = Model{
	finalTime = 500,
	dim = 50,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				cell.state = Random():integer(0, 8)
			end,	
			execute = function(cell)
				local count1 = countNeighbors(cell, 1)
				local count5 = countNeighbors(cell, 5)

				    if cell.past.state == 0 and count1 > 0 then cell.state = 1
				elseif cell.past.state == 1 then cell.state = 2
				elseif cell.past.state == 2 then cell.state = 3
				elseif cell.past.state == 3 and count5 > 0 then cell.state = 4
				elseif cell.past.state == 4 then cell.state = 5
				elseif cell.past.state == 5 then cell.state = 6
				elseif cell.past.state == 6 then cell.state = 7
				elseif cell.past.state == 7 then cell.state = 8
				elseif cell.past.state == 8 then cell.state = 0 end
			end
		}

		model.cs = CellularSpace{
			xdim = model.dim,
			instance = model.cell,
		}

		model.cs:createNeighborhood{strategy = "vonneumann"}

		model.map = Map{
			target = model.cs,
			select = "state",
			min = 0,
			max = 8,
			slices = 9,
			color = "Blues"
		}

		model.timer = Timer{
			Event{action = model.cs}
		}
	end
}

