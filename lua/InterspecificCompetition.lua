
local probabilities = {
	Lolium =    {Lolium = 0.00, Agrostis = 0.02, Holcus = 0.06, Poa = 0.05, Cynosurus = 0.03},
	Agrostis =  {Lolium = 0.23, Agrostis = 0.00, Holcus = 0.09, Poa = 0.32, Cynosurus = 0.37},
	Holcus =    {Lolium = 0.06, Agrostis = 0.08, Holcus = 0.00, Poa = 0.16, Cynosurus = 0.09},
	Poa =       {Lolium = 0.44, Agrostis = 0.06, Holcus = 0.06, Poa = 0.00, Cynosurus = 0.11},
	Cynosurus = {Lolium = 0.03, Agrostis = 0.02, Holcus = 0.03, Poa = 0.05, Cynosurus = 0.00},
}

local initial_location = {7, 15, 23, 31, 39}
local initial_species = {"Agrostis", "Holcus", "Lolium", "Cynosurus", "Poa"}

--- Spatial Interspecific Competition using CA.
-- This model illustrates how species juxtaposition in space can lead to different population
-- dynamics among competitors species.
-- Three Cellular automaton models were constructed to simulate the competitive
-- interaction of five grass species, Agrostis stolonifera, Holcus lanatus, Cynosurus
-- cristatus, Poa trivialis and Lolium perenne, based on experimentally determined
-- rates of invasion.
-- For more information see Cellular Automaton Models of Interspecific Competition for Space
-- The Effect of Pattern on Process. 
-- Author(s): Jonathan Silvertown, Senino Holtier, Jeff Johnson and Pam Dale
-- Source: Journal of Ecology, Vol. 80, No. 3 (Sep., 1992), pp. 527-533.
-- @arg data.finalTime The number of simulation steps. The default value is 500.
-- @arg data.displacements The displacement of the specied in grid (the paper's models).
InterspecificCompetition = Model{
	displacements = Choice{"Random", "ModelA", "ModelB", "ModelC", default = "ModelA"},
	finalTime = 200,
	init = function(model)
		if model.displacements == "ModelA" then
			initial_species = {"Agrostis", "Holcus", "Lolium", "Cynosurus", "Poa"}
		elseif model.displacements == "ModelB" then 
			initial_species = {"Agrostis", "Lolium", "Cynosurus", "Holcus", "Poa"}
		elseif model.displacements == "ModelC" then
			initial_species = {"Agrostis", "Holcus", "Poa", "Cynosurus", "Lolium"}
		end
		
		model.cell = Cell{
			init = function(cell)
				if model.species_displacements == "Random" then
					cell.species = Random{"Agrostis", "Holcus", "Poa", "Cynosurus", "Lolium"}:sample()
				else
					for i = 1, 5 do
						if cell.y <= initial_location[i] then
							cell.species = initial_species[i]
							break
						end
					end
				end
			end,
			execute = function(cell)
				local count_species = {}

				forEachNeighbor(cell, function(_, neighbor)
					local position = neighbor.past.species

					if not count_species[position] then
						count_species[position] = 1
					else
						count_species[position] = count_species[position] + 1
					end
				end)


				local prob_species = {[cell.species] = 0}
				local sum = 0

				forEachElement(count_species, function(species, count)
					prob_species[species] = (count / #cell:getNeighborhood()) * probabilities[species][cell.species]
					sum = sum + prob_species[species]
				end)

				prob_species[cell.species] = prob_species[cell.species] + 1 - sum

				local random = Random(prob_species)

				cell.species = random:sample()
			end
		}

		model.cells = CellularSpace{
			xdim = 40,
			instance = model.cell
		}

		model.cells:createNeighborhood{
			strategy = "vonneumann"
		}

		model.map = Map{
			target = model.cells,
			select = "species",
			value = {"Agrostis", "Holcus", "Lolium", "Cynosurus", "Poa"},
			color = {"orange", "darkGreen", "darkRed", "darkBlue", "lightBlue"}
		}

		model.chart = Chart{
			target = model.cells,
			select = "species",
			value = {"Agrostis", "Holcus", "Lolium", "Cynosurus", "Poa"},
			color = {"orange", "green", "red", "darkBlue", "lightBlue"}
		}

		model.timer = Timer{
			Event{action = model.map},
			Event{action = model.chart},
			Event{action = model.cells} 
		}
	end
}

