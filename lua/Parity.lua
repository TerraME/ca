--- Parity model, by Nigel Gilbert. See 
-- modelingcommons.org/browse/one_model/3381.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.finalTime A number with the final time of the simulation.
-- @image parity.bmp
Parity = Model{
	finalTime = 500,
	dim = 50,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				if (cell.x == 10 and cell.y == 25) or (cell.x == 40 and cell.y == 25) then
					cell.state = "on"
				else
					cell.state = "off"
				end
			end,	
			execute = function(cell)
				local count = countNeighbors(cell, "on")

				if count == 1 or count == 3 then
					cell.state = "on"
				else
					cell.state = "off"
				end
			end
		}

		model.cs = CellularSpace{
			xdim = model.dim,
			instance = model.cell
		}

		model.cs:createNeighborhood{
			strategy = "vonneumann",
			wrap = true
		}

		model.map = Map{
			target = model.cs,
			select = "state",
			value = {"on", "off"},
			color = {"black", "white"}
		}

		model.timer = Timer{
			Event{action = model.cs}
		}
	end
}

