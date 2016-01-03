function love.load()
  inspect = require 'inspect'
  lib = require 'lib'

  testSprite = lib.newSprite(100, 200)
  testSprite:addAnimation('walk', {
    image        = love.graphics.newImage 'mushroom walk.png',
    frameWidth   = 64,
    frameHeight  = 64,
    frames       = {
      {1, 1, 4, 1, .2},
    },
  })
  testSprite:addAnimation('burrow', {
    image       = love.graphics.newImage 'mushroom burrow.png',
    frameWidth  = 64,
    frameHeight = 64,
    stopAtEnd   = true,
    frames      = {
      {1, 1, 12, 1, .05},
    },
  })
  testSprite:switch 'walk'
end

function love.update(dt)
  testSprite:update(dt)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end

  if key == 'space' then
    testSprite:switch 'burrow'
  end
end

function love.draw()
  testSprite:draw()
end
