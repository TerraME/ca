-- Test file for Snow.lua
-- Author: Pedro R. Andrade

return{
	Snow = function(unitTest)
		local model = Snow{
			finalTime = 5
		}

		model:run()
		unitTest:assertSnapshot(model.map, "snow.png")
	end,
}

