-- Test file for Oscillator.lua
-- Author: Pedro R. Andrade

return{
	Oscillator = function(unitTest)
		local model = Oscillator{}

		unitTest:assertSnapshot(model.map, "Oscillator-map-1-begin.bmp")

		model:execute()

		unitTest:assertSnapshot(model.map, "Oscillator-map-1-end.bmp")
	end,
}

