--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the Score state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
		self.bird = params.bird
		self.pipePairs = params.pipePairs
		self.timer = params.timer
		self.score = params.score
		self.lastY = params.lastY
		self.pipeDistance = params.pipeDistance
end

function notEmpty(params)
	if params then
		return true
	else
		return false
	end
end

function PlayState:update(dt)
	-- update timer for pipe spawning
	self.timer = self.timer + dt

	-- spawn a new PipePair if the timer is past 2 seconds
	if self.timer > self.pipeDistance  then
		-- modify the last Y coordinate we placed so pipe gaps aren´t too far apart
		-- no higher than 10 pixels below the top of the edge of the screen,
		-- and no lower than the maximum gap height between pipes from the bottom,
		-- including ground and bottom pipe images height
		local y = math.max(-PIPE_HEIGHT + 10,
			math.min(self.lastY + math.random(-35,35), -PIPE_HEIGHT + (VIRTUAL_HEIGHT - MAX_GAP_HEIGHT - 26)))
		self.lastY = y
			
		table.insert(self.pipePairs, PipePair(self.lastY))

		--assign new random distance between pipes
		self.pipeDistance = math.random(2,4)

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

	-- pressing p pauses the game, transitioning to the PauseState
	if love.keyboard.wasPressed('p') then
		sounds['music']:pause()
		sounds['pause']:play()

		SCROLLING = false


		gStateMachine:change('pause', {
			['bird'] = self.bird,
			['pipePairs'] = self.pipePairs,
			['timer'] = self.timer,
			['score'] = self.score,
			['lastY'] = self.lastY,
			['pipeDistance'] = self.pipeDistance
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