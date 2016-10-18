
--- Return the number of neighbors of a given cell that have a given
-- value in their attribute "state".
-- @arg cell A Cell.
-- @arg val A Value. If missing, this function will return the number
-- of neighbors of the Cell.
-- @usage import("ca")
--
-- Anneal = Model{
--     finalTime = 100,
--     dim = 80,
--     init = function(model)
--         model.cell = Cell{
--             init = function(cell)
--                 if Random():number() > 0.5 then
--                     cell.state = "L"
--                 else
--                     cell.state = "R"
--                 end
--             end,
--             execute = function(cell)
--                 local alive = countNeighbors(cell, "L")
--
--                 if cell.state == "L" then alive = alive + 1 end
--
--                 if alive <= 3 then
--                     cell.state = "R"
--                 elseif alive >= 6 then
--                     cell.state = "L"
--                 elseif alive == 4 then
--                     cell.state = "L"
--                 elseif alive == 5 then
--                     cell.state = "R"
--                 end
--             end
--         }
--
--         model.cs = CellularSpace{
--             xdim = model.dim,
--             instance = model.cell
--         }
--
--         model.cs:createNeighborhood()
--
--         model.timer = Timer{
--             Event{action = model.cs},
--             Event{action = model.map}
--         }
--     end
-- }
function countNeighbors(cell, val)
	if val == nil then
		return #cell:getNeighborhood()
	end

	local count = 0
	forEachNeighbor(cell, function(_, neigh)
		if neigh.past.state == val then
			count = count + 1
		end
	end)
	return count
end

