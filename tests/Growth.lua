-- Test file for Growth.lua
-- Author: Pedro R. Andrade

return{
	Growth = function(unitTest)
		local model = Growth{}

		unitTest:assertSnapshot(model.map, "Growth-map-1-begin.bmp")

		model:execute()

		unitTest:assertSnapshot(model.map, "Growth-map-1-end.bmp")
	end,
}

