-- Test file for SolidDiffusion.lua
-- Author: Pedro R. Andrade

return{
	SolidDiffusion = function(unitTest)
		local model = SolidDiffusion{}

		unitTest:assertSnapshot(model.map, "SolidDiffusion-map-1-begin.bmp")

		model:execute()

		unitTest:assertSnapshot(model.map, "SolidDiffusion-map-1-end.bmp")
	end,
}

