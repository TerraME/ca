--- This model describes how diffusion occurs between two adjacent solids. 
-- It is based on NetLogo Solid Diffusion model http://ccl.northwestern.edu/netlogo/models/SolidDiffusion.
-- Solid diffusion is material transport by atomic motion, this phenomena is exhaustively studied in fields as materials science, physics, biology, geology, engineering and chemistry.
-- In this model we demonstrate that the Vacancy Diffusion Mechanism is caused by missing atoms in the metal crystal (Vacancies). These vacancies are occupied by atoms that move from areas of high concentration of Atom of type B to areas with low concentration, until the concentration is equal throughtout the sample.
-- The first version of this implementation was developed by Yasmine and John, as final work for Environmental Modeling course in
-- Erasmus Mundus program, Munster University, 2014. It still needs further development.
-- @arg data.finalTime The final simulation time.
-- @arg data.dim The x and y dimensions of space.
SolidDiffusion = Model{
	dim = 31,
	finalTime = 400,
	init = function(model)
		model.cell = Cell{
			init = function(cell)
				local middle = math.floor(cell.parent.xdim / 2)
	
				local a = cell.x
	
				if a < middle then
					cell.cover = "atom1"
				elseif a > middle then
					cell.cover = "atom2"
				else -- a == middle 
					cell.cover = "vacancy"
				end	
			end,
			execute = function(cell)
				if cell.past.cover == "vacancy" then
					local neighbor = cell:getNeighborhood():sample()
			
					-- not moving empty neighbors
					if neighbor.past.cover ~= "vacancy" then 
						-- not moving twice the same atom
						if neighbor.cover ~= "vacancy" then 
							-- move
							cell.cover = neighbor.past.cover
							neighbor.cover = "vacancy"		
						end						
					end
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
			select = "cover",
			value = {"vacancy", "atom1", "atom2"},
			color = {"black", "green", "blue"}
		}

		model.timer = Timer{
			Event{action = model.cs}
		}
	end
}

