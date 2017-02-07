
--- Simple growth model. A given population starts from the center of space
-- and grows randomly.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.finalTime A number with the final time of the simulation.
-- @arg data.probability The probability of a cell to become alive once
-- it has an alive neighbor.
-- @image growth.bmp
Growth = Model{
	finalTime = 100,
	dim = 100,
	probability = 0.15,
	random = true,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				if cell.x == model.dim / 2 and cell.y == model.dim / 2 then
					cell.state = "alive"
				else
					cell.state = "empty"
				end
			end,
			execute = function(cell)
				local count = countNeighbors(cell, "alive")

				if cell.past.state == "empty" and count > 0 and Random():number() < model.probability then
					cell.state = "alive"
				end
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
			value = {"alive", "empty"},
			color = {"white", "black"}
		}

		model.timer = Timer{
			Event{action = model.cs},
			Event{action = model.map}
		}
	end
}

