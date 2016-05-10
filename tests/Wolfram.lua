-- Test file for Wolfram.lua
-- Author: Pedro R. Andrade

return{
	Wolfram = function(unitTest)
		local w = Wolfram{
			finalTime = 15
		}

		w:run()

		unitTest:assertSnapshot(w.map, "wolfram.bmp")
	end
}

