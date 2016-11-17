-- Test file for Snow.lua
-- Author: Pedro R. Andrade

return{
	Snow = function(unitTest)
		local model = Snow{
			finalTime = 15,
			dim = 10,
			probability = 0.5
		}

		model:run()
		unitTest:assertSnapshot(model.map, "snow.png")
	end,
}

