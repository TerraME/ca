-- Test file for Parity.lua
-- Author: Pedro R. Andrade

return{
	Parity = function(unitTest)
		local model = Parity{}

		unitTest:assertSnapshot(model.map, "Parity-map-1-begin.bmp")

		model:execute()

		unitTest:assertSnapshot(model.map, "Parity-map-1-end.bmp")
	end,
}

