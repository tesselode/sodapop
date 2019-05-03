local sodapop = {}

local function parseRange(range)
	if type(range) == 'number' then return {range} end
	local numbers = {}
	local first, last = range:gsub '{%d+}%-{%d+}'
	local direction = first > last and -1 or 1
	for i = first, last, direction do
		table.insert(numbers, i)
	end
	return numbers
end

local function parseCoordinates(width, ...)
	local numbers = {}
	for i = 2, select('#', ...) do
		local xRange = select(i, ...)
		local yRange = select(i + 1, ...)
		local xValues = parseRange(xRange)
		local yValues = parseRange(yRange)
		for _, x in ipairs(xValues) do
			for _, y in ipairs(yValues) do
				table.insert(numbers, width * (y - 1) + x)
			end
		end
	end
	return numbers
end

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
		for y = 1, rows do
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

function Sprite:_updateAnimation(animation, dt)
	if animation.currentFrame == #animation.frames and animation.stopAtEnd then
		return
	end
	animation.frameTimer = animation.frameTimer - dt
	while animation.frameTimer <= 0 do
		animation.currentFrame = animation.currentFrame + 1
		if animation.currentFrame > #animation.frames then
			animation.currentFrame = 1
		end
		animation.frameTimer = animation.frameTimer + animation.durations[animation.currentFrame]
	end
end

function Sprite:update(dt)
	if self.parallel then
		for _, animation in pairs(self.animations) do
			self:_updateAnimation(animation, dt)
		end
		return
	end
	self:_updateAnimation(self.animations[self.currentAnimation], dt)
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
