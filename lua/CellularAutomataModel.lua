
--- Template for Cellular Automata Model.
function CellularAutomataModel(data)
	mandatoryTableArgument(data, "map", "table")
	mandatoryTableArgument(data, "changes", "function")
	mandatoryTableArgument(data, "dim", "number")
	optionalTableArgument(data, "init", "function")
	optionalTableArgument(data, "space", "function")

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
		end

		instance.cs:createNeighborhood{wrap = true}

		instance.timer = Timer{
            Event{priority = "high", action = function (ev)
				instance.cs:synchronize()
				instance.cs:changes()
            end},    
			Event{start = 0, priority = "low", action = function()
				instance.cs:notify()
			end}
		}

		instance.map = Map{
			target = instance.cs,
			select = map.select,
			value = map.value,
			color = map.color
		}
	end

	return Model(data)
end

