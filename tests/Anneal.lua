-- Test file for Anneal.lua
-- Author: Pedro R. Andrade

return{
	Anneal = function(unitTest)
		local a = Anneal{
			finalTime = 5
		}

		a:execute()

		unitTest:assertSnapshot(a.map, "anneal.bmp")
	end
}

