-- Test file for Fire.lua
-- Author: Pedro R. Andrade

return{
	Fire = function(unitTest)
		local f = Fire{
			finalTime = 5
		}

		f:execute()

		unitTest:assertSnapshot(f.map, "fire.bmp")
	end,
}

