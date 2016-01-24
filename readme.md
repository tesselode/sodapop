Sodapop
=======
Sodapop is a sprite/animation library for LÖVE. It allows you to create sprites with a variety of animations, and it lets you easily do common transformations when drawing the sprites.

Example
-------
```lua
function love.load()
  sodapop = require 'sodapop'

  playerSprite = sodapop.newAnimatedSprite(100, 200)
  playerSprite:addAnimation('walk', {
    image        = love.graphics.newImage 'walk.png',
    frameWidth   = 64,
    frameHeight  = 64,
    frames       = {
      {1, 1, 4, 1, .2},
    },
  })
  playerSprite:addAnimation('burrow', {
    image       = love.graphics.newImage 'burrow.png',
    frameWidth  = 64,
    frameHeight = 64,
    stopAtEnd   = true,
    frames      = {
      {1, 1, 12, 1, .05},
    },
  })
  playerSprite:addAnimation('unburrow', {
    image        = love.graphics.newImage 'burrow.png',
    frameWidth   = 64,
    frameHeight  = 64,
    stopAtEnd    = true,
    reverse      = true,
    onReachedEnd = function() playerSprite:switch 'walk' end,
    frames       = {
      {1, 1, 12, 1, .05},
    },
  })
end

function love.update(dt)
  playerSprite:update(dt)
end

function love.keypressed(key)
  if key == 'left' then playerSprite.flipX = true end
  if key == 'right' then playerSprite.flipX = false end
  if key == 'down' then playerSprite:switch 'burrow' end
  if key == 'up' then playerSprite:switch 'unburrow' end
end

function love.draw()
  playerSprite:draw()
end
```

API
---
### `sprite = sodapop.newAnimatedSprite(x, y)`

Creates a new sprite.
- `x` (number) - the x coordinate of the center of the sprite.
- `y` (number) - the y coordinate of the center of the sprite.

**Note:** you do not have to include `x` and `y` if you use anchor functions (see below).

### `sprite:addAnimation(name, parameters)`

Adds an animation to the sprite.
- `name` (string) - the name of the animation.
- `parameters` (table) - a table containing parameters.

#### Parameters:
- `image` (image) - the image the animation should use.
- `frameWidth` (number) - the width of each frame of animation.
- `frameHeight` (number) - the height of each frame of animation.
- `stopAtEnd` (boolean, default=`false`) - whether the animation should stop when it reaches the last frame.
- `onReachedEnd` (function, optional) - a function to call when the animation loops back to the first frame, or if `stopAtEnd` is enabled, when it normally loop back to the first frame.
- `reverse` (boolean, default=`false`) - whether the list of frames should be reversed after they are added.
- `frames` (table) - a list of frames. Frames are tables with the form `{x1, y1, x2, y2, duration}`.
  - `x1` (number) - the leftmost frame to load (in frames, not pixels).
  - `y1` (number) - the topmost frame to load (in frames, not pixels).
  - `x2` (number) - the rightmost frame to load (in frames, not pixels).
  - `y2` (number) - the bottommost frame to load (in frames, not pixels).
  - `duration` (number) - how long the frame should last (in seconds).
  - **Note:** frames are added left to right, top to bottom.

#### Example:
```lua
sprite:addAnimation('unburrow', {
  image        = love.graphics.newImage 'burrow.png',
  frameWidth   = 64,
  frameHeight  = 64,
  stopAtEnd    = true,
  reverse      = true,
  onReachedEnd = function() sprite:switch 'walk' end,
  frames       = {
    {1, 1, 3, 4, .05},
    {4, 4, 4, 4, .1},
  },
})
```

### `sprite:switch(name, resume)`

Switches the sprite to a different animation.
- `name` (string) - the name of the animation to switch to.
- `resume` (boolean, default=`false`) - if `true`, the animation will continue from the frame that was playing last; if `false`, it will start over.

### `sprite:goToFrame(frame)`

Jumps to a frame in the current animation.
- `frame` (number) - the frame to jump to.

### `sprite:setAnchor(f)`

Sets an anchor function for the sprite. When the sprite has an anchor function, it will automatically move to the coordinates returned by the function when you call `sprite:update()`. To remove the anchor function, call `sprite:setAnchor()` without any arguments.

#### Example:
```lua
--the sprite will automatically move to the mouse position
sprite:setAnchor(function()
  return love.mouse.getX(), love.mouse.getY()
end)
```

### `sprite:update(dt)`

Updates the sprite.
- `dt` (number) - the time between the current and previous updates.

### ` sprite:draw(ox, oy) `

Draws the sprite.
- `ox` (number, optional) - the horizontal offset to draw the sprite with.
- `oy` (number, optional) - the vertical offset to draw the sprite with.

__Note__: `ox` and `oy` do not take the scale of the sprite into account. They are merely added on to the sprite's position.

### `sprite = sodapop.newSprite(image, x, y)`

A shortcut function for creating a sprite with no animation. This function creates a sprite with one animation named "main" with one frame.
- `image` (image) - the image the sprite should have.
- `x` (number) - the x coordinate of the center of the sprite.
- `y` (number) - the y coordinate of the center of the sprite.

### Properties
Sprites have a number of properties you can set.
- `x` (number) - the x coordinate of the center of the sprite.
- `y` (number) - the y coordinate of the center of the sprite.
- `r` (number, default=`0`) - the rotation of the sprite (around the center, in radians).
- `sx` (number, default=`1`) - the horizontal scale of the sprite.
- `sy` (number, default=`1`) - the vertical scale of the sprite.
- `flipX` (boolean, default=`false`) - whether the sprite should be flipped horizontally.
- `flipY` (boolean, default=`false`) - whether the sprite should be flipped vertically.
- `color` (table, default=`{255, 255, 255, 255}`) - the color the sprite should be drawn with (has the form `{r, g, b, a}`).
- `playing` (boolean, default=`true`) - whether the current animation should play or not.
