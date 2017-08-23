-- Test file for Fire.lua
-- Author: Pedro R. Andrade

return{
	Fire = function(unitTest)
		local f = Fire{
			finalTime = 5
		}

		f:run()

		unitTest:assertSnapshot(f.map, "fire.bmp")

		unitTest:assert(true)
	end,
}

