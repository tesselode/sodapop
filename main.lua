function love.load()
  inspect = require 'inspect'
  lib = require 'lib'

  testSprite = lib.newSprite(100, 200)
  testSprite:addAnimation('main', {
    image        = love.graphics.newImage 'mushroom walk.png',
    frameWidth   = 64,
    frameHeight  = 64,
    stopAtEnd    = true,
    frames       = {
      {1, 1, 4, 1, .1},
    },
  })
  testSprite:switch 'main'
end

function love.update(dt)
  testSprite:update(dt)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end

  if key == 'return' then
    testSprite.current:goToFrame(1)
  end

  if key == 'space' then
    testSprite.current.playing = false
  end
end

function love.draw()
  testSprite:draw()
end
