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
mushroom:addAnimation('burrow', {
  image = love.graphics.newImage 'mushroom burrow.png',
  frameWidth = 64,
  frameHeight = 64,
  stopAtEnd = true,
  frames = {
    {1, 1, 12, 1, .05}
  }
})
mushroom:addAnimation('unburrow', {
  image = love.graphics.newImage 'mushroom burrow.png',
  frameWidth = 64,
  frameHeight = 64,
  reverse = true,
  onReachedEnd = function() mushroom:switch 'walk' end,
  frames = {
    {1, 1, 12, 1, .05}
  }
})

local sliders = {
  rotation = {name = 'Rotation', value = 0, min = 0, max = 2 * math.pi},
  sx = {name = 'Horizontal scale', value = 1, min = 0, max = 5},
  sy = {name = 'Vertical scale', value = 1, min = 0, max = 5},
}

local anchorToMouse = false

function love.update(dt)
  suit.layout:reset(100, 100)
  suit.layout:padding(10, 10)

  -- sliders
  for _, slider in pairs(sliders) do
    suit.Label(slider.name, {align = 'left'}, suit.layout:row(300, 0))
    suit.Slider(slider, suit.layout:row(300, 30))
  end

  -- reset button
  local button = suit.Button('Reset', suit.layout:row(300, 30))
  if button.hit then
    sliders.rotation.value = 0
    sliders.sx.value = 1
    sliders.sy.value = 1
  end

  -- anchor to mouse toggle
  if anchorToMouse then
    local button = suit.Button('Remove anchor', suit.layout:row(300, 30))
    if button.hit then
      anchorToMouse = false
      mushroom:setAnchor()
      mushroom.x, mushroom.y = 600, 200
    end
  else
    local button = suit.Button('Anchor to mouse', suit.layout:row(300, 30))
    if button.hit then
      anchorToMouse = true
      mushroom:setAnchor(function()
        return love.mouse.getX(), love.mouse.getY()
      end)
    end
  end

  -- switch animation buttons
  local button = suit.Button('Burrow', suit.layout:row(145, 30))
  if button.hit then
    mushroom:switch 'burrow'
  end
  local button = suit.Button('Unburrow', suit.layout:col(145, 30))
  if button.hit then
    mushroom:switch 'unburrow'
  end

  -- link sprite properties to sliders
  mushroom.r = sliders.rotation.value
  mushroom.sx = sliders.sx.value
  mushroom.sy = sliders.sy.value

  mushroom:update(dt)
end

function love.draw()
  mushroom:draw()
  suit.draw()
end
