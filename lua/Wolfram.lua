
local function to8Bits(num)
    -- returns a table of bits, most significant first.
    bits = 8
    local t = {} -- will contain the bits        
    for b = bits, 1, -1 do
        t[b] = math.fmod(num, 2)
        num = (num - t[b]) / 2
    end
    local rule = {}
        rule["111"] = t[1]
        rule["110"] = t[2]
        rule["101"] = t[3]
        rule["100"] = t[4]
        rule["011"] = t[5]
        rule["010"] = t[6]
        rule["001"] = t[7]
        rule["000"] = t[8]
    return rule
end

--- Implements Wolfram's one-dimensional Cellular Automata.
-- For more information, see http://mathworld.wolfram.com/ElementaryCellularAutomaton.html.
-- @arg data.finalTime A number with the final time of the simulation. It also indicates
-- the size of space needed to show all the simulation steps.
-- @arg data.rule A number between 0 and 255 with the rule to be used by the
-- automaton.
Wolfram = Model{
    finalTime = 55,
    rule = 90,

    init = function(model)
		integerTableArgument(model, "rule")
		verify(model.rule >= 0, "Rule should be greater than or equal to zero.")
		verify(model.rule <= 255, "Rule should be less than or equal to 255.")

		model.cell = Cell{
			init = function(self)
				self.state = "dead"
			end
		}

	    model.cs = CellularSpace {
        	xdim = model.finalTime * 2 + 3,
        	ydim = model.finalTime + 3,
        	instance = model.cell
       }

        -- set up the rules for each configuration
        model.rules = to8Bits(model.rule)

        -- put a single 1 in the mid point of the first line
        local mid = math.floor((model.cs.xdim + 1 ) / 2 - 1)
        model.cs:get(mid, 0).state = "alive"

		model.map = Map{
			target = model.cs,
			select = "state",
			value = {"dead", "alive"},
			color = {"white", "black"}
		}

	    local changes = function(ev)
        	-- TerraME arrays start at 0, Lua's at 1 
        	for i = 0, model.cs.xdim - 1 do
                -- coordinates of the left, centre and right points
                local leftx   = ((i - 1) > 0) and (i - 1) or (model.cs.xdim - 1)
                local centerx = i
                local rightx  = ((i + 1) == model.cs.xdim) and 0 or (i + 1)
                local yc      = ev:getTime() - 1

                -- values in the three cells above the current one
                local topl = model.cs:get(leftx,   yc).state
                local topc = model.cs:get(centerx, yc).state
                local topr = model.cs:get(rightx,  yc).state

				if topl == "alive" then topl = 1 else topl = 0 end
				if topc == "alive" then topc = 1 else topc = 0 end
				if topr == "alive" then topr = 1 else topr = 0 end

                -- combine the values in a ky from "000" to "111" 
                local conf = ""..topl..topc..topr

				local result = model.rules[conf]
				if result == 0 then
					result = "dead"
				else
					result = "alive"
				end

                -- assign the values to the current cell
                model.cs:get(centerx, yc + 1).state = result
        	end
    	end

		model.timer = Timer{
			Event{action = function(ev)
				changes(ev)
				model.cs:notify()
			end}
		}
	end
}

