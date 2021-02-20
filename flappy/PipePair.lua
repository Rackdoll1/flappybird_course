--[[
    PipePair Class

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used to represent a pair of pipes that stick together as they scroll, providing an opening
    for the player to jump through in order to score a point.
]]

PipePair = Class{}

function PipePair:init(y)

	-- initialize pipes past the right end of the screen
	self.x = VIRTUAL_WIDTH + 32

	-- y value is for the topmost pipe; gap is a vertical shift of the second lower pipe
	self.y = y

	-- instantiate two pipes that belong to this pair
	self.pipes = {
		['upper'] = Pipe('top', self.y),
		['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + math.random(80, 130)) -- random gap height
	}

	-- whenever this pipe is ready to be removed from the scene
	self.remove = false

	-- whether this pair of pipes has been scored (bird passed the right border of pair)
	self.scored = false
end

function PipePair:update(dt)
	-- remove the PipePair from the scene if its beyond the left edge of the screen,
	-- else move it from right to left
	if self.x > -PIPE_WIDTH then
		self.x = self.x - PIPE_SPEED * dt
		self.pipes['upper'].x = self.x
		self.pipes['lower'].x = self.x
	else
		self.remove = true
	end
end

function PipePair:render()
	for k, pipe in pairs(self.pipes) do
		pipe:render()
	end
end 