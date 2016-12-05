-- Test file for BandedVegetation.lua
-- Author: Pedro R. Andrade

return{
	BandedVegetation = function(unitTest)
		local model = BandedVegetation{}

		unitTest:assertSnapshot(model.map, "BandedVegetation-map-1-begin.bmp")

		model:run()

		unitTest:assertSnapshot(model.map, "BandedVegetation-map-1-end.bmp")

		model = BandedVegetation{rainfall = 8}

		model:run()

		unitTest:assertSnapshot(model.map, "BandedVegetation-rainfall.bmp")
	end,
}

