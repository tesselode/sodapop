local sodapop = require 'sodapop'

local sheet = sodapop.newSheet('mushroom.png', 16, 16)

function love.keypressed(key)
	if key == 'escape' then love.event.quit() end
end

function love.draw()
	for i, quad in ipairs(sheet.quads) do
		love.graphics.draw(sheet.image, quad, i * 24, 0)
	end
end
