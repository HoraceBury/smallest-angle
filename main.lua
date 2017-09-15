stage = display.getCurrentStage()

local PI = (4*math.atan(1))
local quickPI = 180 / PI
function angleOf( a, b )
	return math.atan2( b.y - a.y, b.x - a.x ) * quickPI -- 180 / PI -- math.pi
end

-- rotates a point around the (0,0) point by degrees
-- returns new point object
function rotateTo( point, degrees )
	local x, y = point.x, point.y

	local theta = math.rad( degrees )

	local pt = {
		x = x * math.cos(theta) - y * math.sin(theta),
		y = x * math.sin(theta) + y * math.cos(theta)
	}

	return pt
end

function smallestAngleDiff( target, source )
	local a = target - source

	if (a > 180) then
		a = a - 360
	elseif (a < -180) then
		a = a + 360
	end

	return a
end


-- returns the distance between points a and b
function lengthOf( a, b )
    local width, height = b.x-a.x, b.y-a.y
    return (width*width + height*height)^0.5 -- math.sqrt(width*width + height*height)
	-- nothing wrong with math.sqrt, but I believe the ^.5 is faster
end

-- Returns the angle in degrees between the first and second points, measured at the centre
-- Always a positive value
function angleAt( centre, first, second )
	local a, b, c = centre, first, second
	local ab = lengthOf( a, b )
	local bc = lengthOf( b, c )
	local ac = lengthOf( a, c )
	local angle = math.deg( math.acos( (ab*ab + ac*ac - bc*bc) / (2 * ab * ac) ) )
	return angle
end


local circle = display.newCircle(display.contentCenterX, display.contentCenterY, 360)
circle.strokeWidth = 10
circle:setFillColor(0,0,0,0)

local dot = display.newCircle(display.contentCenterX, display.contentCenterY, 50)
dot:setFillColor(255,255,255)

local a = display.newCircle(display.contentCenterX+360, display.contentCenterY, 25)
a:setFillColor(255,0,0)

local b = display.newCircle(display.contentCenterX+360, display.contentCenterY, 25)
b:setFillColor(0,255,0)

local text = display.newText("0",0,0,nil,70)
text.x, text.y = display.contentCenterX, 70

function touch(e)
	local small = smallestAngleDiff( angleOf(circle,a), angleOf(circle,b) )
	
	if (small < 0) then
		print('Left')
		dot:setFillColor(255,0,0)
	elseif (small > 0) then
		print('Right')
		dot:setFillColor(0,255,0)
	else
		print('Straight forward')
		dot:setFillColor(0,0,255)
	end
	
	if (e.phase == "began") then
		e.target.hasFocus = true
		stage:setFocus(e.target)
		return true
	elseif (e.target.hasFocus) then
		if (e.phase == "moved") then
			local at = angleOf(circle,e)
			local pt = rotateTo({x=360,y=0}, at)
			e.target.x, e.target.y = pt.x+display.contentCenterX, pt.y+display.contentCenterY
			
			text.text = small -- angleAt( dot, a, b )
		else
			stage:setFocus(nil)
			e.target.hasFocus = false
		end
		return true
	end
	return false
end

a:addEventListener("touch",touch)
b:addEventListener("touch",touch)
