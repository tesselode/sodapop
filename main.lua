function love.load()
  lib = require 'lib'

  testImage = love.graphics.newImage 'mushroom.png'
  testSprite = lib.newSprite(testImage, 50, 100)
end

function love.keypressed(key)
  if key == 'return' then
    testSprite:centerOrigin()
  end
  if key == 'space' then
    testSprite.flipY = not testSprite.flipY
  end
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  testSprite:draw()
  love.graphics.print(tostring(testSprite.flipX))
end
