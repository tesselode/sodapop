local sodapop = require 'sodapop'

local mushroomSpriteSheet = sodapop.newSheet('mushroom.png', 16, 16)
local sprite = sodapop.newSprite {
	sheet = mushroomSpriteSheet,
	animations = {
		walk = {
			frames = {2, 3, 4, 5},
			durations = {.1, .1, .1, .1},
		},
	},
	startingAnimation = 'walk',
}

function love.update(dt)
	sprite:update(dt)
end

function love.keypressed(key)
	if key == 'escape' then love.event.quit() end
end

function love.draw()
	sprite:draw(50, 50)
end
