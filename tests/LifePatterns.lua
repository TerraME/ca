-- Test file for LifePatterns.lua
-- Author: Pedro R. Andrade

return{
	brianOsc = function(unitTest)
		local cs = brianOsc()

		unitTest:assertType(cs, "CellularSpace")

		local m = Map{
			target = cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"black", "white"}
		}

		unitTest:assertSnapshot(m, "brianosc.bmp")
	end,
	dinnerTable = function(unitTest)
		local cs = dinnerTable()

		unitTest:assertType(cs, "CellularSpace")

		local m = Map{
			target = cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"black", "white"}
		}

		unitTest:assertSnapshot(m, "dinnertable.bmp")
	end,
	figureEight = function(unitTest)
		local cs = figureEight()

		unitTest:assertType(cs, "CellularSpace")

		local m = Map{
			target = cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"black", "white"}
		}

		unitTest:assertSnapshot(m, "figureeight.bmp")
	end,
	glider = function(unitTest)
		local cs = glider()

		unitTest:assertType(cs, "CellularSpace")

		local m = Map{
			target = cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"black", "white"}
		}

		unitTest:assertSnapshot(m, "glider.bmp")
	end,
	heavySpaceship = function(unitTest)
		local cs = heavySpaceship()

		unitTest:assertType(cs, "CellularSpace")

		local m = Map{
			target = cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"black", "white"}
		}

		unitTest:assertSnapshot(m, "heavyspaceship.bmp")
	end,
	insertPattern = function(unitTest)
		unitTest:assert(true)
		--unitTest:assertSnapshot(m, "brianosc.bmp")
	end,
	octagon = function(unitTest)
		local cs = octagon()

		unitTest:assertType(cs, "CellularSpace")

		local m = Map{
			target = cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"black", "white"}
		}

		unitTest:assertSnapshot(m, "octagon.bmp")
	end,
	pentaDecathlon = function(unitTest)
		local cs = pentaDecathlon()

		unitTest:assertType(cs, "CellularSpace")

		local m = Map{
			target = cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"black", "white"}
		}

		unitTest:assertSnapshot(m, "pentadecathlon.bmp")
	end,
	pulsar = function(unitTest)
		local cs = pulsar()

		unitTest:assertType(cs, "CellularSpace")

		local m = Map{
			target = cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"black", "white"}
		}

		unitTest:assertSnapshot(m, "pulsar.bmp")
	end,
	rabbits = function(unitTest)
		local cs = rabbits()

		unitTest:assertType(cs, "CellularSpace")

		local m = Map{
			target = cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"black", "white"}
		}

		unitTest:assertSnapshot(m, "rabbits.bmp")
	end,
	rpentomino = function(unitTest)
		local cs = rpentomino()

		unitTest:assertType(cs, "CellularSpace")

		local m = Map{
			target = cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"black", "white"}
		}

		unitTest:assertSnapshot(m, "rpentomino.bmp")
	end
}

