--[[
    GD50
    Flappy Bird Remake
	flappy-0
	"The Day-0 Update"

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

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual screen dimensions, 16:9 resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- images we load into memory from files to later draw onto the screen
-- in Lua, variables and functions load faster if they are local
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

-- called at the beginning of program execution
function love.load()
	-- texture scaling filter; set to nearest to avoid blurryness
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	-- displayed name at the top of the window
	love.window.setTitle('Fifty Bird')

	-- initialize virtual resolution
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = true
	})
end

function love.resize(w,h)
	push.resize(w, h)
end

-- taking user input
function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.draw()
	push:start()

	-- it takes any drawable object (and image is drawable) and draws it at the given coordinates
	love.graphics.draw(background, 0, 0)

	-- draw the ground on top of the background, toward the bottom of the screen
	love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

	push:finish()
end