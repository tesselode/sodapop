local sodapop = {
  _VERSION     = 'Sodapop',
  _DESCRIPTION = 'A sprite and animation library for LÖVE',
  _URL         = 'https://github.com/tesselode/sodapop',
  _LICENSE     = [[
    The MIT License (MIT)

    Copyright (c) 2016 Andrew Minnich

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
  ]]
}

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

function Animation:reverse()
  local newFrames = {}
  for i = #self.frames, 1, -1 do
    table.insert(newFrames, self.frames[i])
  end
  self.frames = newFrames
end

function Animation:advance()
  if self.current == #self.frames then
    self:onReachedEnd()
    if self.stopAtEnd then
      self.playing = false
    else
      self.current = 1
    end
  else
    self.current = self.current + 1
  end
  if self.playing then
    self.timer = self.timer + self.frames[self.current].duration
  end
end

function Animation:goToFrame(frame)
  assert(frame <= #self.frames, 'Frame number out of range')
  self.current = frame
  self.timer   = self.frames[self.current].duration
  self.playing = true
end

function Animation:update(dt)
  if self.playing then
    self.timer = self.timer - dt
    while self.timer < 0 do
      self:advance()
      if not self.playing then
        break
      end
    end
  end
end

function Animation:draw(x, y, r, sx, sy, flipX, flipY)
  if flipX then sx = -sx end
  if flipY then sy = -sy end

  love.graphics.draw(self.image, self.frames[self.current].quad, x, y,
    r, sx, sy, self.frameWidth / 2, self.frameHeight / 2)
end

local function newAnimation(parameters)
  local animation = {
    image        = parameters.image,
    frameWidth   = parameters.frameWidth,
    frameHeight  = parameters.frameHeight,
    stopAtEnd    = parameters.stopAtEnd,
    onReachedEnd = parameters.onReachedEnd or function() end,
    frames       = {},

    playing     = true,
    current     = 1,
  }
  setmetatable(animation, {__index = Animation})

  for i = 1, #parameters.frames do
    animation:addFrames(unpack(parameters.frames[i]))
  end
  if parameters.reverse then animation:reverse() end
  animation.timer = animation.frames[1].duration

  return animation
end

local Sprite = {}

function Sprite:addAnimation(name, parameters)
  self.animations[name] = newAnimation(parameters)
  if not self.current then self:switch(name) end
end

function Sprite:switch(name, resume)
  assert(self.animations[name], 'No animation named '..name)
  self.current = self.animations[name]
  if resume then else self.current:goToFrame(1) end
end

function Sprite:goToFrame(frame) self.current:goToFrame(frame) end

function Sprite:setAnchor(f)
  self.anchor = f
end

function Sprite:update(dt)
  if self.playing then self.current:update(dt) end
  if self.anchor then
    self.x, self.y = self.anchor()
  end
end

function Sprite:draw(ox, oy)
  ox, oy = ox or 0, oy or 0
  love.graphics.setColor(self.color)
  self.current:draw(self.x + ox, self.y + oy, self.r, self.sx, self.sy,
    self.flipX, self.flipY)
end

function sodapop.newAnimatedSprite(x, y)
  local sprite = {
    animations = {},
    x          = x,
    y          = y,
    r          = 0,
    sx         = 1,
    sy         = 1,
    flipX      = false,
    flipY      = false,
    color      = {255, 255, 255, 255},
    playing    = true,
  }
  setmetatable(sprite, {__index = Sprite})
  return sprite
end

function sodapop.newSprite(image, x, y)
  local sprite = sodapop.newAnimatedSprite(x, y)
  sprite:addAnimation('main', {
    image       = image,
    frameWidth  = image:getWidth(),
    frameHeight = image:getHeight(),
    frames      = {
      {1, 1, 1, 1, 1},
    },
  })
  return sprite
end

return sodapop
