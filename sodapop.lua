local sodapop = {}

local Sheet = {}
Sheet.__index = Sheet

function sodapop.newSheet(image, frameWidth, frameHeight)
	if type(image) == 'string' then
		image = love.graphics.newImage(image)
	end
	local columns = math.ceil(image:getWidth() / frameWidth)
	local rows = math.ceil(image:getHeight() / frameHeight)
	local quads = {}
	for x = 1, columns do
		quads[x] = {}
		for y = 1, rows do
			quads[x][y] = love.graphics.newQuad(
				x * frameWidth, y * frameHeight,
				frameWidth, frameHeight,
				image:getDimensions()
			)
		end
	end
	return {
		image = image,
		quads = quads,
	}
end

local Sprite = {}
Sprite.__index = Sprite

function Sprite:_seekAnimation(animation, frame)
	animation.currentFrame = frame % #animation.frames
	animation.frameTimer = animation.durations[animation.currentFrame]
end

function Sprite:seek(frame)
	if self.parallel then
		for _, animation in pairs(self.animations) do
			self:_seekAnimation(animation, frame)
		end
		return
	end
	self:_seekAnimation(self.animations[self.currentAnimation], frame)
end

function Sprite:switch(animation, resume)
	self.currentAnimation = animation
	if not resume then self:seek(1) end
end

function Sprite:update(dt)
end

function Sprite:draw(x, y)
end

function sodapop.newSprite(sheet, options)
	local animations = {}
	if options.animations then
		for _, animation in ipairs(options.animations) do
			local frames = animation.frames
			local durations = animation.durations
			table.insert(animations, {
				frames = frames,
				durations = durations,
				currentFrame = 1,
				frameTimer = durations[1],
			})
		end
	end
	return setmetatable({
		sheet = sheet,
		frame = options and options.frame,
		animations = animations,
		currentAnimation = options and options.startingAnimation,
		parallel = options and options.parallel,
	}, Sprite)
end

return sodapop
