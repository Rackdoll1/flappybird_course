--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}

local GRAVITY = 20

function Bird:init()
	-- load bird image from disk and assing its width and height
	-- it is initialized here because there will only be one instance of Bird during the game´s execution
	self.image = love.graphics.newImage('bird.png')
	-- image is sort of a "class" in itself, so each image has
	-- some functions already implemented for us to use
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	-- position bird in the middle of the screen
	self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
	self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

	-- Y velocity
	self.dy = 0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)
	-- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
    	if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
    		return true
    	end
    end

    return false
end

function Bird:update(dt)
	-- apply gravity to velocity
	self.dy = self.dy + GRAVITY * dt

	-- add sudden burst of negative gravity if we hit space to simulate wings flap/jump
	if love.keyboard.wasPressed('space') then
		self.dy = -5
	end

	-- apply current velocity to Y position
	self.y = self.y + self.dy
	if self.y < 0 then
		self.y = math.max(0, self.y)
		self.dy = 0.1
	end
end

function Bird:render()
	love.graphics.draw(self.image, self.x, self.y)
end