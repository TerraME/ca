-- Test file for Excitable.lua
-- Author: Pedro R. Andrade

return{
	Excitable = function(unitTest)
		local model = Excitable{}

		unitTest:assertSnapshot(model.map, "Excitable-map-1-begin.bmp")

		model:execute()

		unitTest:assertSnapshot(model.map, "Excitable-map-1-end.bmp")
	end,
}

