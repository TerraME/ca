-- Test file for Utils..lua
-- Author: Pedro R. Andrade

return{
	countNeighbors = function(unitTest)
		local l = Life{}

		l.cs:synchronize()

		forEachCell(l.cs, function(cell)
			unitTest:assert(countNeighbors(cell, "alive") <= 8)
		end)

		unitTest:assertEquals(countNeighbors(l.cs:sample()), 8)
	end
}

