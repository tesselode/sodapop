function love.load()
  lib = require 'lib'
  inspect = require 'inspect'

  testSprite = lib.newSprite(100, 200)
  testSprite:addAnimation('main', {
    image       = love.graphics.newImage 'mushroom.png',
    frameWidth  = 64,
    frameHeight = 64,
    frames      = {
      {1, 1, 1, 1, .1},
    },
  })
  testSprite:switch 'main'
end

function love.draw()
  testSprite:draw()
end
