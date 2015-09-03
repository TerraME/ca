-- Test file for LifePatterns.lua
-- Author: Pedro R. Andrade

return{
	getLife = function(unitTest)
		local function savePattern(pattern)
			local cs = getLife(pattern)

			unitTest:assertType(cs, "CellularSpace")

			local m = Map{
				target = cs,
				select = "state",
				value = {"dead", "alive"},
				color = {"black", "white"}
			}

			unitTest:assertSnapshot(m, pattern..".bmp")
		end

		savePattern("25P3H1")
		savePattern("blocker")
		savePattern("boatTie")
		savePattern("bookend")
		savePattern("dinnerTable")
		savePattern("figureEight")
		savePattern("glider")
		savePattern("heavySpaceship")
		savePattern("octagon")
		savePattern("pentaDecathlon")
		savePattern("pulsar")
		savePattern("rPentomino")
		savePattern("rabbits")
	end,
	insertPattern = function(unitTest)
		local l = Life{pattern = "glider"}
		unitTest:assertSnapshot(l.map, "insertPattern.bmp")
	end
}

