local Sprite = {}

function Sprite:centerOrigin()
  self.ox = self.image:getWidth() / 2
  self.oy = self.image:getHeight() / 2
  if self.x then self.x = self.x + self.ox end
  if self.y then self.y = self.y + self.oy end
end

function Sprite:draw(x, y)
  assert(x or self.x, 'Sprite has no x position. Set sprite.x or pass an x value into sprite:draw()')
  assert(y or self.y, 'Sprite has no y position. Set sprite.y or pass an y value into sprite:draw()')

  x, y = x or self.x, y or self.y

  love.graphics.setColor(self.color)
  love.graphics.draw(self.image, x, y, self.r, self.sx, self.sy, self.ox,
    self.oy, self.kx, self.ky)
end

local function newSprite(image, x, y)
  local sprite = {
    image = image,
    x = x,
    y = y,
    r = 0,
    sx = 1,
    sy = 1,
    ox = 0,
    oy = 0,
    kx = 0,
    ky = 0,
    color = {255, 255, 255},
  }
  setmetatable(sprite, {__index = Sprite})
  return sprite
end

return {
  newSprite = newSprite,
}
