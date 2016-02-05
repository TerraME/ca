local amount = {0, -1, -2, -2, -3, -2, -2, -1, 0, 1, 2, 2, 3, 2, 2, 1}

--- Oscillator model from Ermentrout & Edelstein-Keshet (1993).
-- Cellular Automata Approaches to Biological Modeling.
-- Jornal of Theoretical Biology, 160, 97-133.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.finalTime A number with the final time of the simulation.
-- @image oscillator.bmp
Oscillator = Model{
	finalTime = 400,
	dim = 50,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				cell.state = Random():integer(0, 15)
			end,	
			execute = function(cell)
				local count = countNeighbors(cell, 0)

				if count > 0 then
					cell.state = (cell.past.state + amount[cell.past.state + 1] + 1) % 16
				else
					cell.state = (cell.state + 1) % 16
				end
			end
		}

		model.cs = CellularSpace{
			xdim = model.dim,
			instance = model.cell
		}

		model.cs:createNeighborhood()

		model.map = Map{
			target = model.cs,
			select = "state",
			min = 0,
			max = 15,
			slices = 16,
			color = "Blues"
		}

		model.timer = Timer{
			Event{action = model.cs}
		}
	end
}

