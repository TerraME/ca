-- Test file for LifePatterns.lua
-- Author: Pedro R. Andrade

return{
	getLife = function(unitTest)
		local function missingOne()
			getLife("test/missing-one")
		end
		unitTest:assertError(missingOne, "Line 2 of file 'test/missing-one' does not have the same length (2) of the first line (3).")

		local function wrongChar()
			getLife("test/wrong-char")
		end
		unitTest:assertError(wrongChar, "Invalid character 'Z' in file 'test/wrong-char' (line 2).")



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

