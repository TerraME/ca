-- Test file for Parasit.lua
-- Author: Pedro R. Andrade

return{
	Parasit = function(unitTest)
		local model = Parasit{}

		unitTest:assertSnapshot(model.map, "Parasit-map-1-begin.bmp")

		model:execute()

		unitTest:assertSnapshot(model.map, "Parasit-map-1-end.bmp")
	end,
}

