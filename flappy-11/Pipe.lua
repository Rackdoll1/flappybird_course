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

-- pipe scrolling speed, from right to left
PIPE_SPEED = 60

-- height and width of pipe image, globally accessible
PIPE_HEIGHT = 288
PIPE_WIDTH = 70 

function Pipe:init(orientation, y)
	self.x = VIRTUAL_WIDTH
	self.y = y

	self.width = PIPE_IMAGE:getWidth()
	self.height = PIPE_HEIGHT

	-- for determining the rendering orientation
	self.orientation = orientation
end

-- PipePair updates Pipe for now
function Pipe:update(dt)

end

function Pipe:render()
	-- draw function with new parameters to achieve image flipping
	love.graphics.draw(PIPE_IMAGE, self.x,
		(self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
		0, -- rotation
		1, -- x scale
		self.orientation == 'top' and -1 or 1) -- Y scale 
end