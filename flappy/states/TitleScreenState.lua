--[[
    TitleScreenState Class
    
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

-- using the class library, you can inherit from other classes using "__includes = ClassToInheritFrom"
TitleScreenState = Class{__includes = BaseState}
	
	-- used for making a blinking text
	local textActive = true
	local FLASH_TIME = 0.75

function TitleScreenState:init()
	self.timer = 0
end

-- now we "overwrite" the methods we want to use
function TitleScreenState:update(dt)
	self.timer = self.timer + dt

	if self.timer > FLASH_TIME then
		textActive = not textActive
		self.timer = 0
	end

	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('countdown')
	end
end

function TitleScreenState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf('Fifty Bird', 0, 80, VIRTUAL_WIDTH, 'center')

	-- only draw text when true for blinking effect
	if textActive then
		love.graphics.setFont(mediumFont)
		love.graphics.printf('Press Enter', 0, 150, VIRTUAL_WIDTH, 'center')
	end
end