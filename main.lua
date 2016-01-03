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
  testSprite:addAnimation('unburrow', {
    image        = love.graphics.newImage 'mushroom burrow.png',
    frameWidth   = 64,
    frameHeight  = 64,
    stopAtEnd    = true,
    reverse      = true,
    onReachedEnd = function() testSprite:switch 'walk' end,
    frames       = {
      {1, 1, 12, 1, .05},
    },
  })
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
  if key == 'return' then
    testSprite:switch 'unburrow'
  end

  if key == 'r' then
    testSprite:goToFrame(1)
  end

  if key == 'left' then testSprite.flipX = true end
  if key == 'right' then testSprite.flipX = false end
  if key == 'up' then testSprite.flipY = true end
  if key == 'down' then testSprite.flipY = false end
end

function love.draw()
  testSprite:draw()
end
