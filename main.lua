function love.load()
  lib = require 'lib'

  testImage = love.graphics.newImage 'mushroom.png'
  testSprite = lib.newSprite(testImage)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  testSprite:draw(50, 100)
end
