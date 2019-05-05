local sodapop = require 'sodapop'

local spriteSheets = {
	idle = sodapop.newSheet(love.graphics.newImage 'mushroom.png', 64, 64),
	walk = sodapop.newSheet(love.graphics.newImage 'mushroom walk.png', 64, 64),
	burrow = sodapop.newSheet(love.graphics.newImage 'mushroom burrow.png', 64, 64),
}

local mushroom = sodapop.newSprite {
	animations = {
		walk = {
			sheet = spriteSheets.walk,
			frames = {'1-4', 1},
			durations = {.1, .1, .1, .1},
		},
	},
	startingAnimation = 'walk',
}

function love.update(dt)
	mushroom:update(dt)
end

function love.draw()
	mushroom:draw(50, 50)
end
