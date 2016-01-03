local Animation = {}

function Animation:addFrames(x1, y1, x2, y2, duration)
  for x = x1, x2 do
    for y = y1, y2 do
      table.insert(self.frames, {x = x, y = y, duration = duration})
    end
  end
end

local function newAnimation(parameters)
  local animation = {
    image       = parameters.image,
    frameWidth  = parameters.frameWidth,
    frameHeight = parameters.frameHeight,
    frames      = {},
  }
  setmetatable(animation, {__index = Animation})
  for i = 1, #parameters.frames do
    animation:addFrames(unpack(parameters.frames[i]))
  end
  return animation
end

local Sprite = {}

function Sprite:addAnimation(name, parameters)
  self.animations[name] = newAnimation(parameters)
end

function Sprite:switch(name)
  assert(self.animations[name], 'No animation named '..name)
  self.current = self.animations[name]
end

local function newSprite()
  local sprite = {
    animations = {},
  }
  setmetatable(sprite, {__index = Sprite})
  return sprite
end

return {
  newSprite = newSprite,
}
