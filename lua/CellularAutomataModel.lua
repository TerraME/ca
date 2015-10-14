
--- Template for Cellular Automata Model.
-- @arg data.dim A number with the x and y sizes of space.
-- @arg data.map A table with some parameters to visualize
-- the CellularSpace.
-- @tabular map
-- Map  & Description \
-- "select" & A string with the name of the attribute to be visualized. \
-- "value" &  A table with the possible values of the cellular automata. \
-- "color" & A table with the colors for the respective values.
-- @arg data.init A function that describes how a Cell will be initialized.
-- @arg data.changes A function that describes how each Cell is updated.
-- @usage import("ca")
--
-- Anneal = CellularAutomataModel{
--     finalTime = 30,
--     dim = 80,
--     init = function(cell)
--         if Random():number() > 0.5 then
--             cell.state = "L"
--         else
--             cell.state = "R"
--         end
--     end,
--     changes = function(cell)
--         local alive = countNeighbors(cell, "L")
--
--         if cell.state == "L" then alive = alive + 1 end
--
--         if alive <= 3 then
--             cell.state = "R"
--         elseif alive >= 6 then
--             cell.state = "L"
--         elseif alive == 4 then
--             cell.state = "L"
--         elseif alive == 5 then
--             cell.state = "R"
--         end
--     end,
--     map = {
--         select = "state",
--         value = {"L", "R"},
--         color = {"black", "white"}
--     }
-- }
--
-- Anneal:execute()
function CellularAutomataModel(data)
	mandatoryTableArgument(data, "map", "table")
	mandatoryTableArgument(data, "changes", "function")
	mandatoryTableArgument(data, "dim", "number")
	optionalTableArgument(data, "init", "function")
	optionalTableArgument(data, "space", "function")
	optionalTableArgument(data, "neighborhood", "string")

	local init = data.init
	data.init = nil

	local map = data.map
	data.map = nil

	local changes = data.changes
	data.changes = nil

	local space = data.space
	data.space = nil

	data.init = function(instance)
		instance.cell = Cell{
			init = init,
			changes = changes
		}

		if space then
			instance.cs = space(instance)
			instance.cs.changes = function(self)
				forEachCell(self, function(cell)
					changes(cell)
				end)
			end
		else
			instance.cs = CellularSpace{
				xdim = instance.dim,
				instance = instance.cell
			}

			instance.cs:createNeighborhood{strategy = data.neighborhood}
		end

		instance.timer = Timer{
            Event{priority = "high", action = function (ev)
				instance.cs:synchronize()
				instance.cs:changes(ev)
            end},    
			Event{start = 0, priority = "low", action = function()
				instance.cs:notify()
				instance:notify()
			end}
		}

		instance.map = Map{
			target = instance.cs,
			select = map.select,
			value = map.value,
			color = map.color,
			min = map.min,
			max = map.max,
			slices = map.slices
		}
	end

	return Model(data)
end

