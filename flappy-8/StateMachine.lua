--
-- StateMachine - a state machine
--
-- Usage:
--
-- -- States are only created as need, to save memory, reduce clean-up bugs and increase speed
-- -- due to garbage collection taking longer with more data in memory.
-- --
-- -- States are added with a string identifier and an initialisation function.
-- -- It is expect the init function, when called, will return a table with
-- -- Render, Update, Enter and Exit methods.
--
-- gStateMachine = StateMachine {
-- 		['MainMenu'] = function()
-- 			return MainMenu()
-- 		end,
-- 		['InnerGame'] = function()
-- 			return InnerGame()
-- 		end,
-- 		['GameOver'] = function()
-- 			return GameOver()
-- 		end,
-- }
-- gStateMachine:change("MainGame")
--
-- Arguments passed into the Change function after the state name
-- will be forwarded to the Enter function of the state being changed too.
--
-- State identifiers should have the same name as the state table, unless there's a good
-- reason not to. i.e. MainMenu creates a state using the MainMenu table. This keeps things
-- straight forward.

StateMachine = Class{}

-- states is a table containing the names of each state of the game as keys, and a
-- function returning a specific State object as values
function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end,
	}
	-- lets lets you initialize a value in the function if it´s not given in
	-- the parameters or if its like faulty
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
end

-- the second argument, parameters, is optional
function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- this means state must exit! (optional error message not included)
	self.current:exit() -- call the exit function of the state we are in to do the necessary stuff, like deallocating memory
	self.current = self.states[stateName]() -- this parenthesis means "call whatever function is there"
											-- in our case, its the "create new State object function"
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end	

function StateMachine:render()
	self.current:render()
end