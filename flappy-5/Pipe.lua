--[[
	Pipe Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Pipe class represents the pipes that randomly spawn in our game, which act as our primary obstacles.
    The pipes can stick out a random distance from the top or bottom of the screen. When the player collides
    with one of them, it's game over. Rather than our bird actually moving through the screen horizontally,
    the pipes themselves scroll through the game to give the illusion of player movement.

]]

Pipe = Class{}

-- we don´t put this in init() because there will be many copies of this object; we
-- want the image loaded once to use it multiple times, not per instantiation
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- pipe scrolling velocity
local PIPE_SCROLL = -60 

function Pipe:init()
	self.x = VIRTUAL_WIDTH

	-- set the Y to a random value a quarter below the screen
	self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 50)

	self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
	self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
	love.graphics.draw(PIPE_IMAGE, self.x, self.y) 
end