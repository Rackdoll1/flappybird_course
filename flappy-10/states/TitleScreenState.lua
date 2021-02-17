--[[
    TitleScreenState Class
    
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

-- using the class library, you can inherit from other classes using "__includes = ClassToInheritFrom"
TitleScreenState = Class{__includes = BaseState}

-- now we "overwrite" the methods we want to use
function TitleScreenState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('countdown')
	end
end

function TitleScreenState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end