-- Test file for Parasit.lua
-- Author: Pedro R. Andrade

return{
	Parasit = function(unitTest)
		local model = Parasit{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.map, "Parasit-map-1-begin.bmp")

		model:run()

		unitTest:assertSnapshot(model.map, "Parasit-map-1-end.bmp")
	end,
}

