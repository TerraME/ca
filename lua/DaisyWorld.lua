--- Implementation of a 2D Daisy World model.
-- We have three type of cells: White daisies, Black daisies and soil, with a given albedo for each of them.
-- The cells are placed randomly in the cellular space depending on the given percentage of soil and white daisies, in the remaining there are placed black daisies. Each of them is given with a random initial age, to control the population of daisies, because when they are old (given age) they die.
-- Each cell is also given a random initial value for soil heat between the range of possible values of temperature.
-- Each time step for CA, the temperature will be calculated as follows: Each cell temperature will be calculated according to the daisy albedo and the previous temperature, also the mean neighbours temperature is calculated and this value is used to calculate the mean between the temperature from the cell itself and the mean of the neighbours.
-- If there is an empty cell with a daisy as neighbour, and the conditions for reproduction are fulfilled, a new daisy will be born in the empty cell.
-- The conditions for reproduction are that the daisy's ground has to be inside the range of temperatures, and if it is in the given perfect temperature to reproduce it will have 100 % of chances to reproduce, and less chances the further it is from the perfect temperature. The new born daisy will be the same type as the maximum neighbourhood type (black or white).
-- The daisies will die on a certain (given) age.
-- The first version of this implementation was developed by Nourhan, Shahin and Aida, as final work for Environmental Modeling course in
-- Erasmus Mundus program, Munster University, 2014. It still needs further development.
-- @arg data.proportion A table with two indexes, empty and white, describing the initial proportions of empty and white cells.
-- @arg data.reproduceTemperature A table with temperatures related to reproduction.
-- @arg data.temperature A table with the temperatures: max for maximum temperature, min for minimum temperature, reproduceMin for the minimum
-- temperature that makes the daisies reproductible, reproducePerfect for the temperature daisies will reproduce with a probability of 100%,
-- and reproduceMax for the maximum temperature where daisies can reproduce.
-- @arg data.finalTime The final simulation time.
-- @arg data.lifeSpan How long does a daisy live?
-- @arg data.dim The x and y dimensions of space.
-- @arg data.albedo A table with white and black albedos.
-- @image daisy.bmp
DaisyWorld = Model{
	dim = 50,
	finalTime = 200,
	lifeSpan = 5,
	temperature = {
		min = 0,
		max = 100
	},
	albedo = {
		white = 0.2,
		black = 0.7
	},
	reproduceTemperature = {
		max = 70,
		min = 40,
		perfect = 50
	},
	proportion = {
		empty = 0.7,
		white = 0.6 * 0.3
	},
	interface = function()
		return {
			{"number", "proportion", "albedo"},
			{"temperature", "reproduceTemperature"},
		}
	end,
	init = function(self)
		local function calculateProbRepro(soilHeat)
			local diff = math.abs(self.reproduceTemperature.perfect - soilHeat)
			return 100 - diff
		end

		self.rand = Random{seed = 1}

		self.proportion.black = 1 - self.proportion.empty - self.proportion.white

		self.cell = Cell{
			soilHeat = 50,
			lifeSpan = Random{min = 0, max = 4, step = 1},
			daisy = Random(self.proportion),
			die = function(cell)
				cell.lifeSpan = 0
				cell.daisy = "empty"
			end,
			born = function(cell)
				local blackDaisyCounter = 0
				local whiteDaisyCounter = 0

				forEachNeighbor(cell, function(_, neigh) 
					if neigh.past.daisy == "black" then 
						blackDaisyCounter = blackDaisyCounter + 1
					elseif neigh.past.daisy == "white" then
						whiteDaisyCounter = whiteDaisyCounter + 1
					end 
				end)

				cell.lifeSpan = 0

				if whiteDaisyCounter > blackDaisyCounter then
					cell.daisy = "white"
				elseif whiteDaisyCounter < blackDaisyCounter then
					cell.daisy = "black"
				elseif whiteDaisyCounter > 0 then  -- equal
					if self.rand:number(0, 1) < 0.5 then
						cell.daisy = "white"
					else
						cell.daisy = "black"
					end 
				end
			end,
			calculateSoilHeat = function(cell)
				local selfHeat

				if cell.past.daisy == "white" then  --increment or decrement temperature depending on the daisy
					selfHeat = cell.past.soilHeat - cell.past.soilHeat * self.albedo.white
				elseif cell.past.daisy == "black"  then 
					selfHeat = cell.past.soilHeat + cell.past.soilHeat * self.albedo.black
				else
					selfHeat = cell.past.soilHeat
				end

				local neigbourHeat = 0 --change temperature to make it similar to the neigbours
				local neighbourCount = 0

				forEachNeighbor(cell, function(_, neigh) 
					neighbourCount = neighbourCount + 1
					neigbourHeat = neigbourHeat + neigh.past.soilHeat
				end)

				neigbourHeat = neigbourHeat / neighbourCount -- calculate the mean of the neighbours
				local heat = (selfHeat + neigbourHeat) / 2

				heat = math.min(heat, self.temperature.max) --make heat value inside the valid range
				heat = math.max(heat, self.temperature.min)
	
				return heat
			end,
			execute = function(cell)
				if cell.past.daisy ~= "empty" then
					cell.lifeSpan = cell.lifeSpan + 1
				end
		
				if cell.past.lifeSpan >= self.lifeSpan then
					 cell:die()
				end
		
				cell.soilHeat = cell:calculateSoilHeat()
		
				if cell.past.daisy == "empty" and cell.past.soilHeat > self.reproduceTemperature.min and cell.past.soilHeat< self.reproduceTemperature.max then
					local probabilityReproduce = calculateProbRepro(cell.past.soilHeat)
					if self.rand:number() * 100 < probabilityReproduce then
						cell:born()
					end
				end
			end
		}

		self.cs = CellularSpace{
			xdim = self.dim,
			instance = self.cell,
			blackDaisy = function(cs) return #cs:split("daisy").black end,
			whiteDaisy = function(cs) return #cs:split("daisy").white end,
			emptySpace = function(cs) return #cs:split("daisy").empty end
		}

		self.cs:createNeighborhood{
			strategy = "vonneumann",
			wrap = true
		}
	
		self.map1 = Map{
			target = self.cs,
			select = "soilHeat",
			slices = 6,
			max = self.temperature.max,
			min = self.temperature.min,
			color = {"yellow", "red"}
		}

		self.map2 = Map{
			target = self.cs,
			select = "daisy",
			value = {"black", "white", "empty"},
			color = {"black", "white", "green"}
		}

		self.chart = Chart{
			target = self.cs,
			select = {"blackDaisy", "whiteDaisy", "emptySpace"}, 
			title ="Population x Time",
			yLabel = "#individual"
		}

		self.timer = Timer{
			Event{action = self.cs},
			Event{action = self.chart},
			Event{action = self.map1},
			Event{action = self.map2}
		}
	end
} 

