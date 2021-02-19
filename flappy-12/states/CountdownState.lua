--[[
    Countdown State
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin. Transitions to the PlayState as soon as the
    countdown is complete.
]]

CountdownState = Class{__includes = BaseState}

-- takes a little less than 1 second to count down each time
COUNTDOWN_TIME = 0.75

function CountdownState:init()
	self.count = 3
	self.timer = 0
	sounds['count']:play()
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]

function CountdownState:update(dt)
	self.timer = self.timer + dt

	if self.timer > COUNTDOWN_TIME then
		self.timer = self.timer % COUNTDOWN_TIME
		self.count = self.count - 1

		if self.count > 0 then
			sounds['count']:play()
		end

		if self.count == 0 then
			gStateMachine:change('play')
		end

	end
end

function CountdownState:render()
	love.graphics.setFont(hugeFont)
	love.graphics.printf(tostring(self.count), 0, 90, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press Spacebar to Jump!', 0, 180, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(smallFont)
	love.graphics.printf('(Left Mouse Button works too!)', 0, 205, VIRTUAL_WIDTH, 'center')
end