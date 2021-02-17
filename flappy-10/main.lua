--[[
    GD50
    Flappy Bird Remake
	flappy-9
	"The Countdown Update"

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

-- class representing a pair of pipes (top, bottom)
require 'PipePair'

-- classes related to game state and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

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

-- point at which we should loop our ground back to X = 0
local GROUND_LOOPING_POINT = 514

-- called at the beginning of program execution
function love.load()
	-- texture scaling filter; set to nearest to avoid blurryness
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	-- displayed name at the top of the window
	love.window.setTitle('Fifty Bird')

	-- initialize our nice-looking retro text fonts
	smallFont = love.graphics.newFont('font.ttf', 8)
	mediumFont = love.graphics.newFont('flappy.ttf', 14)
	flappyFont = love.graphics.newFont('flappy.ttf', 28)
	hugeFont = love.graphics.newFont('flappy.ttf', 56)
	love.graphics.setFont(flappyFont)

	-- seed the rng
	math.randomseed(os.time())

	-- initialize virtual resolution
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = true
	})

	-- initialize state machine with all state-returning functions 
	-- lua lets you omit () if the only argument of a function is one table
	gStateMachine = StateMachine{
		-- In Lua, functions can be stored in variables (both global and local),
		-- and in tables
		['title'] = function() return TitleScreenState() end,
		['countdown'] = function() return CountdownState() end,
		['play'] = function() return PlayState() end,
		['score'] = function() return ScoreState() end,
 	}
 	gStateMachine:change('title')

	-- initialize own defined input table
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
	New function used to check our global input table for keys we activated during
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
		% GROUND_LOOPING_POINT

	-- now we just update the state machine, which defers to the right state
	gStateMachine:update(dt)
	-- reset input table
	love.keyboard.keyPressed = {}
end

function love.draw()
	push:start()

	-- draw state machine between the background and the ground, which defers
	-- render logic to the currently active state
	love.graphics.draw(background, -backgroundScroll, 0)
	-- each state has its own render logic
	gStateMachine:render()

	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - ground:getHeight())

	push:finish()
end