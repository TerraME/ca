--- Anneal model from Toffoli & Margolis (1988).
-- Cellular Automata Machines: A New Environment for Modeling.
-- Cambridge, MA. MIT Press.
-- @arg data.dim The x and y dimensions of space.
-- @arg data.finalTime A number with the final time of the simulation.
-- @image anneal.bmp
Anneal = Model{
	finalTime = 100,
	dim = 80,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				if Random():number() > 0.5 then
					cell.state = "L"
				else
					cell.state = "R"
				end
			end,
			execute = function(cell)
				local alive = countNeighbors(cell, "L")

				if cell.state == "L" then alive = alive + 1 end

				if alive <= 3 then
					cell.state = "R"
				elseif alive >= 6 then
					cell.state = "L"
				elseif alive == 4 then
					cell.state = "L"
				elseif alive == 5 then
					cell.state = "R"
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
			value = {"L", "R"},
			color = {"black", "white"}
		}

		model.timer = Timer{
			Event{action = model.cs}
		}
	end
}

