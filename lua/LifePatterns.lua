
--- Insert a given pattern in a CellularSpace.
-- @arg cs1 A CellularSpace to receive the pattern.
-- @arg cs2 A CellularSpace with the pattern.
-- @arg x0 The x position where the pattern will be copied on the CellularSpace.
-- @arg y0 The y position where the pattern will be copied on the CellularSpace.
-- @usage insertPattern(cs, glider(), 0, 0)
function insertPattern(cs1, cs2, x0, y0)
	for i = 0, (cs2.ydim - 1) do
		for j = 0, (cs2.xdim - 1) do
			cs1:get(x0 + j, y0 + i).state = cs2:get(j, i).state
		end
	end
end

--- Return a CellularSpace with Brian OSC pattern.
-- @usage brianOsc()
function brianOsc()
	local cs = CellularSpace{
		xdim = 4
	}
	forEachCell(cs, function(cell)
		cell.state = "dead"
	end)

	cs:get(1, 1).state = "alive"
	cs:get(1, 2).state = "alive"
	cs:get(2, 1).state = "alive"
	cs:get(2, 2).state = "alive"
	cs:get(1, 0).state = DYING
	cs:get(0, 2).state = DYING
	cs:get(2, 3).state = DYING
	cs:get(3, 1).state = DYING

	return cs
end

--- Return a CellularSpace with glider pattern.
-- @usage glider()
function glider()
	local cs = CellularSpace{
		xdim = 3
	}
	forEachCell(cs, function(cell)
		cell.state = "dead"
	end)

	cs:get(1, 0).state = "alive"
	cs:get(2, 1).state = "alive"
	cs:get(0, 2).state = "alive"
	cs:get(1, 2).state = "alive"
	cs:get(2, 2).state = "alive"

	return cs
end

--- Return a CellularSpace with pulsar pattern.
-- @usage pulsar()
function pulsar()
	local cs = CellularSpace{
		xdim = 13
	}
	forEachCell(cs, function(cell)
		cell.state = "dead"
	end)

	cs:get( 2, 0).state = "alive"
	cs:get( 3, 0).state = "alive"
	cs:get( 4, 0).state = "alive"

	cs:get( 8, 0).state = "alive"
	cs:get( 9, 0).state = "alive"
	cs:get(10, 0).state = "alive"

	cs:get( 0, 2).state = "alive"
	cs:get( 5, 2).state = "alive"
	cs:get( 7, 2).state = "alive"
	cs:get(12, 2).state = "alive"

	cs:get( 0, 3).state = "alive"
	cs:get( 5, 3).state = "alive"
	cs:get( 7, 3).state = "alive"
	cs:get(12, 3).state = "alive"

	cs:get( 0, 4).state = "alive"
	cs:get( 5, 4).state = "alive"
	cs:get( 7, 4).state = "alive"
	cs:get(12, 4).state = "alive"

	cs:get( 2, 5).state = "alive"
	cs:get( 3, 5).state = "alive"
	cs:get( 4, 5).state = "alive"

	cs:get( 8, 5).state = "alive"
	cs:get( 9, 5).state = "alive"
	cs:get(10, 5).state = "alive"

	cs:get( 2, 7).state = "alive"
	cs:get( 3, 7).state = "alive"
	cs:get( 4, 7).state = "alive"

	cs:get( 8, 7).state = "alive"
	cs:get( 9, 7).state = "alive"
	cs:get(10, 7).state = "alive"

	cs:get( 0, 8).state = "alive"
	cs:get( 5, 8).state = "alive"
	cs:get( 7, 8).state = "alive"
	cs:get(12, 8).state = "alive"

	cs:get( 0, 9).state = "alive"
	cs:get( 5, 9).state = "alive"
	cs:get( 7, 9).state = "alive"
	cs:get(12, 9).state = "alive"

	cs:get( 0, 10).state = "alive"
	cs:get( 5, 10).state = "alive"
	cs:get( 7, 10).state = "alive"
	cs:get(12, 10).state = "alive"

	cs:get( 2, 12).state = "alive"
	cs:get( 3, 12).state = "alive"
	cs:get( 4, 12).state = "alive"

	cs:get( 8, 12).state = "alive"
	cs:get( 9, 12).state = "alive"
	cs:get(10, 12).state = "alive"

	return cs
end

--- Return a CellularSpace with figure-eight pattern.
-- @usage figureEight()
function figureEight()
	local cs = CellularSpace{
		xdim = 6
	}

	forEachCell(cs, function(cell)
		cell.state = "dead"
	end)

	cs:get(0, 0).state = "alive"
	cs:get(1, 0).state = "alive"

	cs:get(0, 1).state = "alive"
	cs:get(1, 1).state = "alive"
	cs:get(3, 1).state = "alive"

	cs:get(4, 2).state = "alive"

	cs:get(1, 3).state = "alive"

	cs:get(2, 4).state = "alive"
	cs:get(4, 4).state = "alive"
	cs:get(5, 4).state = "alive"

	cs:get(4, 5).state = "alive"
	cs:get(5, 5).state = "alive"

	return cs
end

--- Return a CellularSpace with octagon pattern.
-- @usage octagon()
function octagon()
	local cs = CellularSpace{
		xdim = 8
	}

	forEachCell(cs, function(cell)
		cell.state = "dead"
	end)

	cs:get(3, 0).state = "alive"
	cs:get(4, 0).state = "alive"

	cs:get(2, 1).state = "alive"
	cs:get(5, 1).state = "alive"

	cs:get(1, 2).state = "alive"
	cs:get(6, 2).state = "alive"

	cs:get(0, 3).state = "alive"
	cs:get(7, 3).state = "alive"

	cs:get(0, 4).state = "alive"
	cs:get(7, 4).state = "alive"

	cs:get(1, 5).state = "alive"
	cs:get(6, 5).state = "alive"

	cs:get(2, 6).state = "alive"
	cs:get(5, 6).state = "alive"
	
	cs:get(3, 7).state = "alive"
	cs:get(4, 7).state = "alive"

	return cs
end

--- Return a CellularSpace with penta decathlon pattern.
-- @usage pentaDecathlon()
function pentaDecathlon()
	local cs = CellularSpace{
		xdim = 10,
		ydim = 3
	}
	forEachCell(cs, function(cell)
		cell.state = "dead"
	end)

	cs:get(2, 0).state = "alive"
	cs:get(7, 0).state = "alive"

	cs:get(0, 1).state = "alive"
	cs:get(1, 1).state = "alive"
	cs:get(3, 1).state = "alive"
	cs:get(4, 1).state = "alive"
	cs:get(5, 1).state = "alive"
	cs:get(6, 1).state = "alive"
	cs:get(8, 1).state = "alive"
	cs:get(9, 1).state = "alive"

	cs:get(2, 2).state = "alive"
	cs:get(7, 2).state = "alive"

	return cs
end

--- Return a CellularSpace with rpentomino pattern.
-- @usage rpentomino()
function rpentomino()
	local cs = CellularSpace{
		xdim = 3
	}
	forEachCell(cs, function(cell)
		cell.state = "dead"
	end)

	cs:get(1, 0).state = "alive"
	cs:get(2, 0).state = "alive"
	cs:get(0, 1).state = "alive"
	cs:get(1, 1).state = "alive"
	cs:get(1, 2).state = "alive"

	return cs
end

--- Return a CellularSpace with dinnerTable pattern.
-- @usage dinnerTable()
function dinnerTable()
	local cs = CellularSpace{
		xdim = 13
	}

	forEachCell(cs, function(cell)
		cell.state = "dead"
	end)

	cs:get( 1, 0).state = "alive"
	cs:get( 1, 1).state = "alive"
	cs:get( 2, 1).state = "alive"
	cs:get( 3, 1).state = "alive"
	cs:get(11, 1).state = "alive"
	cs:get(12, 1).state = "alive"
	cs:get( 4, 2).state = "alive"
	cs:get(11, 2).state = "alive"
	cs:get( 3, 3).state = "alive"
	cs:get( 4, 3).state = "alive"
	cs:get( 9, 3).state = "alive"
	cs:get(11, 3).state = "alive"
	cs:get( 9, 4).state = "alive"
	cs:get(10, 4).state = "alive"
	cs:get( 5, 6).state = "alive"
	cs:get( 6, 6).state = "alive"
	cs:get( 7, 6).state = "alive"
	cs:get( 5, 7).state = "alive"
	cs:get( 6, 7).state = "alive"
	cs:get( 7, 7).state = "alive"
	cs:get( 2, 8).state = "alive"
	cs:get( 3, 8).state = "alive"
	cs:get( 1, 9).state = "alive"
	cs:get( 3, 9).state = "alive"
	cs:get( 8, 9).state = "alive"
	cs:get( 9, 9).state = "alive"
	cs:get( 1, 10).state = "alive"
	cs:get( 8, 10).state = "alive"
	cs:get( 0, 11).state = "alive"
	cs:get( 1, 11).state = "alive"
	cs:get( 9, 11).state = "alive"
	cs:get(10, 11).state = "alive"
	cs:get(11, 11).state = "alive"
	cs:get(11, 12).state = "alive"

	return cs
end

--- Return a CellularSpace with heavy spaceship pattern.
-- @usage heavySpaceship()
function heavySpaceship()
	local cs = CellularSpace{
		xdim = 7
	}

	forEachCell(cs, function(cell)
		cell.state = "dead"
	end)

	cs:get(3, 0).state = "alive"
	cs:get(4, 0).state = "alive"
	cs:get(1, 1).state = "alive"
	cs:get(6, 1).state = "alive"
	cs:get(0, 2).state = "alive"
	cs:get(0, 3).state = "alive"
	cs:get(6, 3).state = "alive"
	cs:get(0, 4).state = "alive"
	cs:get(1, 4).state = "alive"
	cs:get(2, 4).state = "alive"
	cs:get(3, 4).state = "alive"
	cs:get(4, 4).state = "alive"
	cs:get(5, 4).state = "alive"

	return cs
end

--- Return a CellularSpace with rabbits pattern.
-- @usage rabbits()
function rabbits()
	local cs = CellularSpace{
		xdim = 7
	}

	forEachCell(cs, function(cell)
		cell.state = "dead"
	end)

	cs:get(0, 0).state = "alive"
	cs:get(0, 4).state = "alive"
	cs:get(0, 5).state = "alive"
	cs:get(0, 6).state = "alive"
	cs:get(1, 0).state = "alive"
	cs:get(1, 1).state = "alive"
	cs:get(1, 2).state = "alive"
	cs:get(1, 5).state = "alive"
	cs:get(2, 1).state = "alive"

	return cs
end

