-- Test file for Influenza.lua
-- Author: Pedro R. Andrade

return{
	Influenza = function(unitTest)
		local model = Influenza{
			finalTime = 75
		}

		unitTest:assertSnapshot(model.map, "Influenza-map-1-begin.bmp")

		model:run()

		unitTest:assertSnapshot(model.chart, "Influenza-chart-1.bmp")
		unitTest:assertSnapshot(model.map, "Influenza-map-1-end.bmp")
	end,
}

