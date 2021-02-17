--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.bird = Bird()
	-- table of spawning PipePairs (instead of individual pipes)
	self.pipePairs = {}
	-- kep track of time passed for spawning pies
	self.timer = 0
	--  initialize our last recorded Y value for a gap placement to base other gaps off of
	self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
	-- update timer for pipe spawning
	self.timer = self.timer + dt

	-- spawn a new PipePair if the timer is past 2 seconds
	if self.timer > 2 then
		-- modify the last Y coordinate we placed so pipe gaps aren´t too far apart
		-- no higher than 10 pixels below the top of the edge of the screen,
		-- and no lower than a gap´s length (90 pixels from the bottom)
		local y = math.max(-PIPE_HEIGHT + 10,
			math.min(self.lastY + math.random(-20,20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
		self.lastY = y
			
		table.insert(self.pipePairs, PipePair(self.lastY))

		-- reset timer
		self.timer = 0
	end

	-- for every PipePair in the scene...
	for k, pair in pairs(self.pipePairs) do
		pair:update(dt)
	end

	-- remove any flagged pipes
	-- we need this second loop, rather than deleting in the previous loop, because
	-- modifying the table in-place without explicit keys will result in skipping the
	-- next pipe, since all implicit keys (numerical indices) are automatically shifted
	-- down after a table removal
	for k, pair in pairs(self.pipePairs) do
	    if pair.remove then
	    	table.remove(self.pipePairs, k)
	    end
	end

	-- update bird with input and gravity
	self.bird:update(dt)

	-- check to see if bird collided with all pipes in pairs
	for k, pair in pairs(self.pipePairs) do
		for l, pipe in pairs(pair.pipes) do
			if self.bird:collides(pipe) then
				-- return to titlescreen
				gStateMachine:change('title')
			end
		end
	end

	if self.bird.y > VIRTUAL_HEIGHT - 15 then
		gStateMachine:change('title')
	end
end

function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	self.bird:render()
end	