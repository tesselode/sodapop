function love.load()
  lib = require 'lib'

  testImage = love.graphics.newImage 'mushroom.png'
  testSprite = lib.newSprite(testImage, 50, 100)
  testSprite:setAnchorFunction(function()
    return love.mouse.getX(), love.mouse.getY()
  end)

  uptime = 0
end

function love.update(dt)
  uptime = uptime + dt
  testSprite:update(dt)
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
