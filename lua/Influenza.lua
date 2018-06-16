local cstate = {
    dead = "dead",
    healthy = "healthy",
    infected = "infected",
    expressing = "expressing",
    infectious = "infectious"
}

local immstate = {
    virgin = "virgin",
    mature = "mature"
}

--- Influenza A model by Beauchemin, Catherine, John Samuel, and Jack Tuszynski.
-- "A simple cellular automaton model for influenza A viral infections."
-- Journal of theoretical biology 232.2 (2005): 223-234.
--
-- Authors: Matheus Cavassan Zaglia, Fabiana Zioti, Gabriel Sansigolo
--
-- @arg data.xdim The x dimension of the space.
-- @arg data.ydim The y dimension of the space.
-- @arg data.flow_rate The number of CA time steps corresponding to 1h in real time.
-- @arg data.finalTime The final time of the CA
-- @arg data.imm_lifespan The lifespan of the immune cell.
-- @arg data.cell_lifespan The lifespan of the epithelial cell.
-- @arg data.infect_lifespan The lifespan of an infected epithelial cell.
-- @arg data.infect_init The probability of an epithelial cell starting as infectious.
-- @arg data.infect_rate The infection spread probability. infect_rate/8 (neighbours)
-- @arg data.infect_delay The delay to an expressing epithelial cell becoming infectious.
-- @arg data.express_delay The delay to an infected epithelial cell becoming expressing.
-- @arg data.division_time The probability per unit time that any dead epithelial cell is revived. (1/division_time) / (#healthy_cells/#dead_cells)
-- @arg data.recruit_delay The waiting delay of a newly recruited immune cell to become active.
-- @arg data.recruitment The chance of recruiting a mature immune cell.
-- @arg data.base_imm_cell The starting number of immune cells.
Influenza = Model{
    xdim = Choice{min = 1, max = 440, step = 1, default = 40},
    ydim = Choice{min = 1, max = 280, step = 1, default = 40},
    flow_rate = 6,
    finalTime = 300,
    imm_lifespan = 168,
    cell_lifespan = 380,
    infect_lifespan = 24,
    infect_init = 0.01,
    infect_rate = Choice{min = 0, max = 8, step=1, default=2},
    infect_delay = 6,
    express_delay = 4,
    division_time = 12,
    base_imm_cell = 0,
    recruit_delay = 7,
    recruitment = Choice{min=0.00, max=1, step=0.01, default = 0.25},


    init = function(model)
        model.finalTime = model.finalTime * model.flow_rate
        model.base_imm_cell = math.ceil(model.ydim * model.xdim * 0.00015)
        dead_count = 0
        healthy_count = 0

        model.cell  = Cell{
            infected_time = 0,
            state = Random{healthy = 1 - model.infect_init, infectious = model.infect_init},
            init = function(cell)
                if cell.state == cstate.healthy then
                    healthy_count = healthy_count + 1
                    cell.age = Random{min = 0, max = model.cell_lifespan}:sample()
                else
                    cell.age = Random{min = 0, max = model.infect_lifespan}:sample()
                end
            end, -- init
            execute = function(cell)
                if cell.state == cstate.dead then
                    cell:divide()
                else
                    if cell.state == cstate.healthy then --healthy cells
                        -- dies if age > cell_lifespan
                        if cell.age > model.cell_lifespan then
                            cell:die()
                        else
                            cell:infect()
                            cell.age = cell.age + 1
                        end
                    else -- infected, expressing, infectious cells
                        --  dies if age > infect_lifespan
                        if cell.age > model.infect_lifespan then
                            cell:die()
                        else
                            -- if not infectious check express and infect delay
                            if cell.state ~= cell.infectious then
                                -- if infected_time >  express_delay, becomes expressing
                                if cell.infected_time > model.express_delay then
                                    cell.state = cstate.expressing
                                end
                                -- if infected_time >  infect_delay, becomes infectious
                                if cell.infected_time > model.infect_delay then
                                    cell.state = cstate.infectious
                                end
                                cell.infected_time = cell.infected_time + 1
                            end
                            cell.age = cell.age + 1
                        end
                    end
                end
            end -- execute
        }


        function model.cell:die()
            if self.state == cstate.healthy then
                healthy_count = healthy_count - 1
            end
            self.state = cstate.dead
            dead_count = dead_count + 1
        end -- cell:die

        function model.cell:divide()
            prob = ((1 / model.division_time) * (healthy_count / dead_count))
            d = Random{p = prob}
            if d:sample() then
                self.state = cstate.healthy
                self.age = 0
                healthy_count = healthy_count + 1
                dead_count = dead_count - 1
            end
            self:infect()
        end -- cell:divide

        function model.cell:infect()
            if self.state == cstate.healthy then
                forEachNeighbor(self, function(neighbor)
                    if neighbor.state == cstate.infectious and self.state == cstate.healthy then
                        infect = Random{p = model.infect_rate / 8 }
                        if infect:sample() then
                            self.state = cstate.infected
                            healthy_count = healthy_count - 1
                            return true
                        end
                    end
                end)
            end
        end -- cell:infect

        model.agent = Agent{
            age = Random{min = 0, max = model.imm_lifespan},
            state = immstate.virgin,
            delay = 0,

            execute = function(agent)
                if agent.delay > 0 then
                    if model.timer:getTime() % (agent.delay * model.flow_rate) == 0 then
                        agent.delay = agent.delay - 1
                    end
                else
                    if agent.age > model.imm_lifespan * model.flow_rate then
                        agent:die()
                    else
                        cell = agent:getCell()
                        if cell.state == cstate.expressing or cell.state == cstate.infectious then
                            if agent.state == immstate.virgin then
                                agent.state = immstate.mature
                            else
                                cell:die()
                                s = Random{p = model.recruitment}
                                if s:sample() then
                                    a = model.society:add()
                                    a.state = immstate.mature
                                    a.delay = model.recruit_delay
                                    a:enter(model.cs:sample())
                                end
                            end
                        end
                        agent:walk()
                        agent.age = agent.age + 1
                    end
                end
            end -- execute
        } -- agent

        model.society = Society{
            instance = model.agent,
            quantity = model.base_imm_cell
        } -- society

        model.cs = CellularSpace{
            xdim = model.xdim,
            instance = model.cell
        } -- cellspace

        model.cs:createNeighborhood{wrap = true}

        model.environment = Environment{
            model.society,
            model.cs
        } -- enviroment

        model.environment:createPlacement{}

        model.map = Map{
            target = model.cs,
            select = "state",
            value = {cstate.dead, cstate.healthy, cstate.infected, cstate.expressing, cstate.infectious},
            color = {"white", "green", "yellow", "orange", "red"}
        } -- map

        model.chart = Chart{
            target = model.cs,
            select = "state",
            value = {cstate.dead, cstate.healthy, cstate.infected, cstate.expressing, cstate.infectious},
            color = {"black", "green", "yellow", "orange", "red"}
        } -- chart

        model.timer = Timer{
            Event{period = model.flow_rate, action = model.cs},
            Event{period = model.flow_rate, action = model.map},
            Event{action = model.society},
            Event{period = model.flow_rate, action = function()
                      if #model.society < model.base_imm_cell then
                          agent = model.society:add()
                          agent:enter(model.cs:sample())
                      end
                  end} -- base_imm_cell maintenance
        } -- timer
    end -- model.init
}
