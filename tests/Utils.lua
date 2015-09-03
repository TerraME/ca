-- Test file for Utils..lua
-- Author: Pedro R. Andrade

return{
	countNeighbors = function(unitTest)
		local l = Life{}

		unitTest:assertEquals(countNeighbors(l.cs:sample(), "alive"), 0)
	end
}

