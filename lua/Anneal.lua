--- Anneal model from Toffoli & Margolis (1988).
-- Cellular Automata Machines: A New Environment for Modeling.
-- Cambridge, MA. MIT Press.
Anneal = CellularAutomataModel{
	finalTime = 100,
	dim = 80,
	init = function(cell)
		if Random():number() > 0.5 then
			cell.state = "L"
		else
			cell.state = "R"
		end
	end,
	changes = function(cell)
		local alive = countNeighbors(cell, "L")

		if cell.state == "L" then alive = alive + 1 end

		if alive <= 3 then
			cell.state = "R"
		elseif alive >= 6 then
			cell.state = "L"
		elseif alive == 4 then
			cell.state = "L"
		elseif alive == 5 then
			cell.state = "R"
		end
	end,
	map = {
		select = "state",
		value = {"L", "R"},
		color = {"black", "white"}
	}
}

