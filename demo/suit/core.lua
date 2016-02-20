-- This file is part of SUIT, copyright (c) 2016 Matthias Richter

local NONE = {}
local BASE = (...):match('(.-)[^%.]+$')
local default_theme = require(BASE..'theme')

local suit = {}
suit.__index = suit

function suit.new(theme)
	return setmetatable({
		-- TODO: deep copy/copy on write? better to let user handle => documentation?
		theme = theme or default_theme,
		mouse_x = 0, mouse_y = 0,
		mouse_button_down = false,

		draw_queue = {n = 0},

		Button = require(BASE.."button"),
		ImageButton = require(BASE.."imagebutton"),
		Label = require(BASE.."label"),
		Checkbox = require(BASE.."checkbox"),
		Input = require(BASE.."input"),
		Slider = require(BASE.."slider"),

		layout = require(BASE.."layout").new(),
	}, suit)
end

-- helper
function suit.getOptionsAndSize(opt, ...)
	if type(opt) == "table" then
		return opt, ...
	end
	return {}, opt, ...
end

-- gui state
function suit:anyHovered()
	return self.hovered ~= nil
end

function suit:isHovered(id)
	return id == self.hovered
end

function suit:wasHovered(id)
	return id == self.hovered_last
end

function suit:isActive(id)
	return id == self.active
end

function suit:getStateName(id)
	if self:isActive(id) then
		return "active"
	elseif self:isHovered(id) then
		return "hovered"
	end
	return "normal"
end

-- mouse handling
function suit:mouseInRect(x,y,w,h)
	return self.mouse_x >= x and self.mouse_y >= y and
	       self.mouse_x <= x+w and self.mouse_y <= y+h
end

function suit:registerMouseHit(id, ul_x, ul_y, hit)
	if hit(self.mouse_x - ul_x, self.mouse_y - ul_y) then
		self.hovered = id
		if self.active == nil and self.mouse_button_down then
			self.active = id
		end
	end
	return self:getStateName(id)
end

function suit:registerHitbox(id, x,y,w,h)
	return self:registerMouseHit(id, x,y, function(x,y)
		return x >= 0 and x <= w and y >= 0 and y <= h
	end)
end

function suit:mouseReleasedOn(id)
	return not self.mouse_button_down and self:isActive(id) and self:isHovered(id)
end

function suit:updateMouse(x, y, button_down)
	self.mouse_x, self.mouse_y = x,y
	if button_down ~= nil then
		self.mouse_button_down = button_down
	end
end

function suit:getMousePosition()
	return self.mouse_x, self.mouse_y
end

-- keyboard handling
function suit:getPressedKey()
	return self.key_down, self.textchar
end

function suit:keypressed(key)
	self.key_down = key
end

function suit:textinput(char)
	self.textchar = char
end

function suit:grabKeyboardFocus(id)
	if self:isActive(id) then
		if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
			if id == NONE then
				love.keyboard.setTextInput( false )
			else
				love.keyboard.setTextInput( true )
			end
		end
		self.keyboardFocus = id
	end
	return self:hasKeyboardFocus(id)
end

function suit:hasKeyboardFocus(id)
	return self.keyboardFocus == id
end

function suit:keyPressedOn(id, key)
	return self:hasKeyboardFocus(id) and self.key_down == key
end

-- state update
function suit:enterFrame()
	self.hovered_last, self.hovered = self.hovered, nil
	self:updateMouse(love.mouse.getX(), love.mouse.getY(), love.mouse.isDown(1))
	self.key_down, self.textchar = nil, ""
	self:grabKeyboardFocus(NONE)
end

function suit:exitFrame()
	if not self.mouse_button_down then
		self.active = nil
	elseif self.active == nil then
		self.active = NONE
	end
end

-- draw
function suit:registerDraw(f, ...)
	local args = {...}
	local nargs = select('#', ...)
	self.draw_queue.n = self.draw_queue.n + 1
	self.draw_queue[self.draw_queue.n] = function()
		f(unpack(args, 1, nargs))
	end
end

function suit:draw()
	self:exitFrame()
	for i = 1,self.draw_queue.n do
		self.draw_queue[i]()
	end
	self.draw_queue.n = 0
	self:enterFrame()
end

return suit
