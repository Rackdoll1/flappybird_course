--[[
    GD50
    Flappy Bird Remake
	flappy-6
	"The PipePair Update"

	*BASED ON  CS50´s Introduction to Game Development course given by:

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple 
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping 
    the screen, making the player's bird avatar flap its wings and move upwards slightly. 
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]

-- virtual resolution handling library
push = require 'push'

-- OOP class library
Class = require 'class'

-- our own created classes
require 'Bird'

require 'Pipe'

require 'PipePair'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual screen dimensions, 16:9 resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- images we load into memory from files to later draw onto the screen
-- in Lua, variables and functions load faster if they are local

-- background image and starting scroll location(X axis)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

-- ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- speed at which we should scroll our images, scaled by *dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X = 0 
local BACKGROUND_LOOPING_POINT = 413

-- our bird sprite
local bird = Bird()

-- table of spawning PipePairs (instead of individual pipes)
local pipePairs = {}

-- kep track of time passed for spawning pies
local spawnTimer = 0

--  initialize our last recorded Y value for a gap placement to base other gaps off of
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- called at the beginning of program execution
function love.load()
	-- texture scaling filter; set to nearest to avoid blurryness
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	-- displayed name at the top of the window
	love.window.setTitle('Fifty Bird')

	-- seed the rng
	math.randomseed(os.time())

	-- initialize virtual resolution
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = true
	})

	-- initialize own defined input table called "keyPressed" (different from keypressed(), a function)
	love.keyboard.keyPressed = {}
end

function love.resize(w,h)
	push.resize(w, h)
end

-- taking user input
function love.keypressed(key)
	-- add to our table of keys pressed this frame
	love.keyboard.keyPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

--[[
	New function used to check our global imut table for keys we activated during
	this frame, looked up by their string value
]]
function love.keyboard.wasPressed(key)
	if love.keyboard.keyPressed[key] then
		return true
	else
		return false
	end
end

function love.update(dt)
	-- scroll background by preset speed * dt, looping back to 0 after the looping point
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
		% BACKGROUND_LOOPING_POINT

	-- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
		% VIRTUAL_WIDTH

	spawnTimer = spawnTimer + dt

	-- spawn a new PipePair if the timer is past 2 seconds
	if spawnTimer > 2 then
		-- modify the last Y coordinate we placed so pipe gaps aren´t too far apart
		-- no higher than 10 pixels below the top of the edge of the screen,
		-- and no lower than a gap´s length (90 pixels from the bottom)
		local y = math.max(-PIPE_HEIGHT + 10,
			math.min(lastY + math.random(-20,20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
		lastY = y
		
		table.insert(pipePairs, PipePair(lastY))
		spawnTimer = 0
	end

	-- update bird with input and gravity
	bird:update(dt)

	-- for every PipePair in the scene...
	for k, pair in pairs(pipePairs) do
		pair:update(dt)
	end

	-- remove any flagged pipes
	-- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(pipePairs) do
    	if pair.remove then
    		table.remove(pipePairs, k)
    	end
    end

	-- reset input table
	love.keyboard.keyPressed = {}
end

function love.draw()
	push:start()

	-- we draw images shifted to the left by their looping point; that is,
	-- after a certain distance has elapsed, they will revert back to 0,
	-- giving the ilussion of infinite scrolling. The key is choosing a
	-- seamless looping point

	-- draw the background at the negative looping point
	love.graphics.draw(background, -backgroundScroll, 0)

	-- draw all pipes in our scene (behind the ground)
	for k, pair in pairs(pipePairs) do
		pair:render()
	end

	-- draw the ground on top of the background, toward the bottom of the screen
	-- at its negative looping point
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

	-- draw bird with its own render logic
	bird:render()

	push:finish()
end