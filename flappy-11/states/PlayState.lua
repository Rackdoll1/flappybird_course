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

	-- keep track of our score
	self.score = 0

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
		-- score a point if the pipe has gone past the left border of the bird
		-- ignore it if it´s already been scored
		if not pair.scored then
			if pair.x + PIPE_WIDTH < self.bird.x then
				self.score = self.score + 1
				pair.scored = true
				sounds['score']:play()
			end
		end

		-- update position of pair
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
				sounds['explosion']:play()
				sounds['hurt']:play()
				
				-- go to score screen, passing a table with the score as a parameter
				gStateMachine:change('score', {
					score = self.score
				})
			end
		end
	end

	-- if bird touches ground, go to score screen, passing a table with the score as a parameter
	if self.bird.y > VIRTUAL_HEIGHT - 15 then
		sounds['explosion']:play()
		sounds['hurt']:play()

		gStateMachine:change('score', {
					score = self.score
				})
	end
end

function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	-- display current score
	love.graphics.setFont(flappyFont)
	love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

	self.bird:render()
end	