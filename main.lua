function love.load()
  lib = require 'lib'
  inspect = require 'inspect'

  testSprite = lib.newSprite()
  testSprite:addAnimation('main', {
    image       = love.graphics.newImage 'mushroom.png',
    frameWidth  = 16,
    frameHeight = 16,
    frames      = {
      {1, 1, 1, 1, .1},
    },
  })
  testSprite:switch 'main'

  print(inspect(testSprite))
end
