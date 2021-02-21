--[[
	PauseState Class
	Author: Jose Chamorro

	A simple state used for pausing the game. Transitioned from the
	PlayState if the player presses P, and resumes if pressed again.
]]

PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
	self.bird = params.bird
	self.pipePairs = params.pipePairs
	self.timer = params.timer
	self.score = params.score
	self.lastY = params.lastY
	self.pipeDistance = params.pipeDistance
end

function PauseState:update(dt)
	if love.keyboard.wasPressed('p') then
		SCROLLING = true

		sounds['pause']:play()
		sounds['music']:play()

		gStateMachine:change('play', {
			['bird'] = self.bird,
			['pipePairs'] = self.pipePairs,
			['timer'] = self.timer,
			['score'] = self.score,
			['lastY'] = self.lastY,
			['pipeDistance'] = self.pipeDistance
		})
	end
end 

function PauseState:render()

	self.bird:render()
	
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	love.graphics.setFont(flappyFont)
	love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

	love.graphics.setFont(hugeFont)
	love.graphics.printf('Paused', 0, VIRTUAL_HEIGHT / 2 - 44, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press P to resume', 0, 174, VIRTUAL_WIDTH, 'center')
end

