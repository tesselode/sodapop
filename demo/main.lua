local sodapop = require 'sodapop'
local suit = require 'suit'

local mushroom = sodapop.newAnimatedSprite(600, 200)
mushroom:addAnimation('walk', {
  image = love.graphics.newImage 'mushroom walk.png',
  frameWidth = 64,
  frameHeight = 64,
  frames = {
    {1, 1, 4, 1, .15}
  }
})

local sliders = {
  rotation = {name = 'Rotation', value = 0, min = 0, max = 2 * math.pi},
  sx = {name = 'Horizontal scale', value = 1, min = 0, max = 5},
  sy = {name = 'Vertical scale', value = 1, min = 0, max = 5},
}

function love.update(dt)
  suit.layout:reset(100, 100)
  suit.layout:padding(10, 10)

  -- sliders
  for _, slider in pairs(sliders) do
    suit.Label(slider.name, {align = 'left'}, suit.layout:row(300, 0))
    suit.Slider(slider, suit.layout:row(300, 30))
  end

  mushroom.r = sliders.rotation.value
  mushroom.sx = sliders.sx.value
  mushroom.sy = sliders.sy.value
  mushroom:update(dt)
end

function love.draw()
  mushroom:draw()
  suit.draw()
end
