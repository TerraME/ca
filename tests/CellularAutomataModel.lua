-- Test file for CellularAutomataModel.lua
-- Author: Pedro R. Andrade

return{
	CellularAutomataModel = function(unitTest)
		local w = Wolfram{
			finalTime = 30
		}

		w:execute()

		unitTest:assertSnapshot(w.map, "ca-test.bmp")
	end
}

