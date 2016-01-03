local Animation = {}

function Animation:addFrames(x1, y1, x2, y2, duration)
  for x = x1, x2 do
    for y = y1, y2 do
      table.insert(self.frames, {
        quad = love.graphics.newQuad(
          self.frameWidth * (x - 1),
          self.frameHeight * (y - 1),
          self.frameWidth,
          self.frameHeight,
          self.image:getWidth(),
          self.image:getHeight()
        ),
        duration = duration,
      })
    end
  end
end

function Animation:advance()
  self.current = self.current + 1
  if self.current > #self.frames then
    self.current = 1
  end
  self.timer = self.timer + self.frames[self.current].duration
end

function Animation:update(dt)
  self.timer = self.timer - dt
  while self.timer < 0 do
    self:advance()
  end
end

function Animation:draw(x, y)
  love.graphics.draw(self.image, self.frames[self.current].quad, x, y)
end

local function newAnimation(parameters)
  local animation = {
    image       = parameters.image,
    frameWidth  = parameters.frameWidth,
    frameHeight = parameters.frameHeight,
    frames      = {},
    loop        = parameters.loop or true,
    current     = 1,
  }
  setmetatable(animation, {__index = Animation})

  for i = 1, #parameters.frames do
    animation:addFrames(unpack(parameters.frames[i]))
  end

  animation.timer = animation.frames[1].duration

  return animation
end

local Sprite = {}

function Sprite:addAnimation(name, parameters)
  self.animations[name] = newAnimation(parameters)
  if not self.current then self:switch(name) end
end

function Sprite:switch(name)
  assert(self.animations[name], 'No animation named '..name)
  self.current = self.animations[name]
end

function Sprite:update(dt)
  self.current:update(dt)
end

function Sprite:draw()
  love.graphics.setColor(255, 255, 255)
  self.current:draw(self.x, self.y)
end

local function newSprite(x, y)
  local sprite = {
    x          = x,
    y          = y,
    animations = {},
  }
  setmetatable(sprite, {__index = Sprite})
  return sprite
end

return {
  newSprite = newSprite,
}
