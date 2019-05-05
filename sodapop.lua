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

return sodapop
