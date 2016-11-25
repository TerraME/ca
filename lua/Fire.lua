--- A Model to simulate fire in the forest.
-- @arg data.finalTime A number with the final simulation time.
-- @arg data.dim A number with the x and y size of space.
-- @arg data.empty The percentage of empty cells in the beginning of the
-- simulation. It must be a value between 0 and 1, with default 0.1.
-- @image fire.bmp
Fire = Model{
	finalTime = 100,
	empty = Choice{min = 0, max = 1, default = 0.1},
	dim = 60,
	random = true,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				if Random():number() > model.empty then
					cell.state = "forest"
				else
					cell.state = "empty"
				end
			end,
			execute = function(cell)
				if cell.past.state == "burning" then
					cell.state = "burned"
				elseif cell.past.state == "forest" then
					local burning = countNeighbors(cell, "burning")

					if burning > 0 then
						cell.state = "burning"
					end
				end
			end
		}

		model.cs = CellularSpace{
			xdim = model.dim,
			instance = model.cell
		}

		model.cs:sample().state = "burning"
		model.cs:createNeighborhood{strategy = "vonneumann"}

		model.chart = Chart{
			target = model.cs,
			select = "state",
			value = {"forest", "burning", "burned"},
			color = {"green", "red", "brown"}
		}

		model.map = Map{
			target = model.cs,
			select = "state",
			value = {"forest", "burning", "burned", "empty"},
			color = {"green", "red", "brown", "white"}
		}

		model.timer = Timer{
			Event{action = model.cs},
			Event{action = model.chart},
			Event{action = model.map}
		}
	end
}

