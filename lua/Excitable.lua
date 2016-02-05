
--- Excitable model from Wiener & Rosenbleuth (1946).
-- Arch. Inst. Cardiol. Mexico 16, 202-265.
-- Reffered in Ermentrout & Edelstein-Keshet (1993).
-- Cellular Automata Approaches to Biological Modeling.
-- Jornal of Theoretical Biology, 160, 97-133.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.finalTime A number with the final time of the simulation.
-- @image excitable.bmp
Excitable = Model{
	finalTime = 500,
	dim = 50,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				if (cell.x == 20 and cell.y == 25) or (cell.x == 30 and cell.y == 25) then
					cell.state = 1
				else
					cell.state = 0
				end
			end,	
			execute = function(cell)
				if cell.past.state == 0 then
					forEachNeighbor(cell, function(cell, neigh)
						if neigh.past.state > 0 then
							cell.state = 1
						end
					end)
				elseif cell.past.state == 1 then cell.state = 2
				elseif cell.past.state == 2 then cell.state = 3
				elseif cell.past.state == 3 then cell.state = 4
				elseif cell.past.state == 4 then cell.state = 5
				elseif cell.past.state == 5 then cell.state = 0 end
			end
		}

		model.cs = CellularSpace{
			xdim = model.dim,
			instance = model.cell
		}

		model.cs:createNeighborhood{strategy = "vonneumann"}

		model.timer = Timer{
			Event{action = model.cs}
		}

		model.map = Map{
			target = model.cs,
			select = "state",
			min = 0,
			max = 5,
			slices = 6,
			color = "Blues"
		}
	end
}

