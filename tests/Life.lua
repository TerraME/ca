-- Test file for Life.lua
-- Author: Pedro R. Andrade

return{
	Life = function(unitTest)
		local l = Life{
			pattern = "glider",
			finalTime = 5
		}

		l:run()

		unitTest:assertSnapshot(l.map, "life.bmp")

		l = Life{
			finalTime = 5
		}

		l:run()

		unitTest:assertSnapshot(l.map, "life-2.bmp")
	end
}

