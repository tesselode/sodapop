local sodapop = {}

function sodapop.newSheet(image, frameWidth, frameHeight)
	if type(image) == 'string' then
		image = love.graphics.newImage(image)
	end
	local columns = math.ceil(image:getWidth() / frameWidth)
	local rows = math.ceil(image:getHeight() / frameHeight)
	local quads = {}
	for y = 0, rows - 1 do
		for x = 0, columns - 1 do
			table.insert(quads, love.graphics.newQuad(
				x * frameWidth, y * frameHeight,
				frameWidth, frameHeight,
				image:getDimensions()
			))
		end
	end
	return {
		image = image,
		quads = quads,
	}
end

local Sprite = {}
Sprite.__index = Sprite

function Sprite:update(dt)
	local animation = self.animations[self.currentAnimation]
	animation.timer = animation.timer - dt
	while animation.timer <= 0 do
		animation.currentFrame = animation.currentFrame + 1
		if animation.currentFrame > #animation.frames then
			animation.currentFrame = 1
		end
		animation.timer = animation.timer + animation.durations[animation.currentFrame]
	end
end

function Sprite:draw(x, y)
	local animation = self.animations[self.currentAnimation]
	local frame = animation.frames[animation.currentFrame]
	local quad = self.sheet.quads[frame]
	love.graphics.draw(self.sheet.image, quad, x, y)
end

function sodapop.newSprite(options)
	if not options then error('must provide an options table', 2) end
	local animations = {}
	for animationName, animation in pairs(options.animations) do
		animations[animationName] = {
			frames = animation.frames,
			durations = animation.durations,
			currentFrame = 1,
			timer = animation.durations[1],
		}
	end
	return setmetatable({
		sheet = options.sheet,
		animations = animations,
		currentAnimation = options.startingAnimation,
	}, Sprite)
end

return sodapop
