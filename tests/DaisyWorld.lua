-- Test file for DaisyWorld.lua
-- Author: Pedro R. Andrade

return{
	DaisyWorld = function(unitTest)
		local model = DaisyWorld{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.map1, "DaisyWorld-map-1-begin.bmp", 0.1)
		unitTest:assertSnapshot(model.map2, "DaisyWorld-map-2-begin.bmp", 0.1)

		model:run()

		unitTest:assertSnapshot(model.chart, "DaisyWorld-chart-1.bmp", 0.1)
		unitTest:assertSnapshot(model.map1, "DaisyWorld-map-1-end.bmp", 0.1)
		unitTest:assertSnapshot(model.map2, "DaisyWorld-map-2-end.bmp", 0.1)
	end,
}

