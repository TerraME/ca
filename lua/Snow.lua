--- Snow falling from the sky.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.finalTime A number with the final time of the simulation.
-- @arg data.probability The probability of a cell on the top of space
-- to change its state to snow.
-- @image snow.bmp
Snow = Model{
	finalTime = 600,
	dim = 50,
	probability = 0.02,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				cell.state = "empty"
			end,	
			execute = function(cell, ev)
				if cell.y == 0 then
					if cell.past.state == "empty" and ev:getTime() < model.finalTime - model.dim and Random():number() < model.probability then
						cell.state = "snow"
					else
						cell.state = "empty"
					end
				elseif cell.past.state == "snow" and cell.y < model.dim - 1 and cell.parent:get(cell.x, cell.y + 1).past.state == "empty" then
					cell.state = "empty"
				elseif cell.parent:get(cell.x, cell.y - 1).past.state == "snow" then
					cell.state = "snow"
				end
			end
		}

		model.cs = CellularSpace{
			xdim = model.dim,
			instance = model.cell,
		}

		model.cs:createNeighborhood{strategy = "vonneumann"}

		map = Map{
			target = model.cs,
			select = "state",
			value = {"snow", "empty"},
			color = {"white", "black"}
		}

		model.timer = Timer{
			Event{action = model.cs}
		}
	end
}

