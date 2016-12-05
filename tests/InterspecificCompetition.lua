-- Test file for InterspecificCompetition.lua
-- Author: Pedro R. Andrade

return{
	InterspecificCompetition = function(unitTest)
		local model = InterspecificCompetition{finalTime = 5}

		unitTest:assertSnapshot(model.map, "InterspecificCompetition-map-1-begin.bmp")

		model:run()

		unitTest:assertSnapshot(model.chart, "InterspecificCompetition-chart-1.bmp")
		unitTest:assertSnapshot(model.map, "InterspecificCompetition-map-1-end.bmp")

		model = InterspecificCompetition{displacements = "Random", finalTime = 5}

		unitTest:assertSnapshot(model.map, "InterspecificCompetition-map-2-begin.bmp")
	end
}

