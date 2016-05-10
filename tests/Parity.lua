-- Test file for Parity.lua
-- Author: Pedro R. Andrade

return{
	Parity = function(unitTest)
		local model = Parity{
			finalTime = 5
		}

		unitTest:assertSnapshot(model.map, "Parity-map-1-begin.bmp")

		model:run()

		unitTest:assertSnapshot(model.map, "Parity-map-1-end.bmp")
	end,
}

