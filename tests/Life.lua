-- Test file for Life.lua
-- Author: Pedro R. Andrade

return{
	Life = function(unitTest)
		local error_func = function()
			Life{
				pattern = "glider",
				dim = 2,
				finalTime = 5
			}
		end
		unitTest:assertError(error_func, "CellularSpace should have dim at least 3.")

		error_func = function()
			Life{
				pattern = "heavySpaceship",
				dim = 6,
				finalTime = 7
			}
		end
		unitTest:assertError(error_func, "CellularSpace should have dim at least 7.")


		local l = Life{
			pattern = "glider",
			finalTime = 5
		}

		l:run()

		unitTest:assertSnapshot(l.map, "life.bmp", 0.1)

		l = Life{
			finalTime = 5
		}

		l:run()

		unitTest:assertSnapshot(l.map, "life-2.bmp")
	end
}

