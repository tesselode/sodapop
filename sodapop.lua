local sodapop = {}

local function parseRanges(...)
	local numbers = {}
	for i = 1, select('#', ...) do
		local range = select(i, ...)
		if type(range) == 'number' then
			table.insert(numbers, range)
		else
			local first, last = range:match '(%d+)%-(%d+)'
			local direction = first > last and -1 or 1
			for j = first, last, direction do
				table.insert(numbers, j)
			end
		end
	end
	return numbers
end

local function parseCoordinates(width, ...)
	local numbers = {}
	for i = 1, select('#', ...), 2 do
		local xRange = select(i, ...)
		local yRange = select(i + 1, ...)
		local xValues = parseRanges(xRange)
		local yValues = parseRanges(yRange)
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
	for y = 1, rows do
		for x = 1, columns do
			table.insert(quads, love.graphics.newQuad(
				x * frameWidth, y * frameHeight,
				frameWidth, frameHeight,
				image:getDimensions()
			))
		end
	end
	return {
		columns = columns,
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
	if self.animations then
		local currentAnimation = self.animations[self.currentAnimation]
		local sheet = currentAnimation.sheet or self.sheet
		local quad = sheet.quads[currentAnimation.frames[currentAnimation.currentFrame]]
		love.graphics.draw(sheet.image, quad, x, y)
	elseif self.frame then
		local quad = self.sheet.quads[self.frame]
		love.graphics.draw(self.sheet.image, quad, x, y)
	end
end

function sodapop.newSprite(options)
	local animations
	if options.animations then
		animations = {}
		for animationName, animation in pairs(options.animations) do
			local frames = parseCoordinates(animation.sheet.columns, unpack(animation.frames))
			local durations = type(animation.durations) == 'number' and {animation.durations}
			               or parseRanges(unpack(animation.durations))
			animations[animationName] = {
				sheet = animation.sheet,
				frames = frames,
				durations = durations,
				currentFrame = 1,
				frameTimer = durations[1],
			}
		end
	end
	return setmetatable({
		sheet = options and options.sheet,
		frame = options and options.frame,
		animations = animations,
		currentAnimation = options and options.startingAnimation,
		parallel = options and options.parallel,
	}, Sprite)
end

return sodapop
