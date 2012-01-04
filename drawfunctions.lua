
module(..., package.seeall)

local squareWidth = 0
local squareHeight = 0 

function drawCirlce(x, y, xoffset, yoffset)
   local circle = display.newCircle(x + xoffset *squareWidth, y+ yoffset *squareHeight, squareWidth/3)
   circle:setFillColor(0,0,0,0)
   circle.strokeWidth = 7
   circle:setStrokeColor(255, 255,0)
   return circle
end

function drawCross(xMin, yMin, xMax, yMax, xoffset, yoffset)
    local notedge = 15
    
    print(math.ceil(xMin + xoffset *squareWidth + notedge))
    print(math.ceil(yMin + yoffset *squareHeight +notedge))
    print(math.ceil(xMax + xoffset *squareWidth -notedge))
    print(math.ceil(yMax + yoffset *squareHeight -notedge))
    



    local line = display.newLine(math.ceil(xMin + xoffset *squareWidth + notedge), math.ceil(yMin + yoffset *squareHeight +notedge), math.ceil(xMax + xoffset *squareWidth -notedge), math.ceil(yMax + yoffset *squareHeight -notedge))
    local line2 = display.newLine(xMin + xoffset *squareWidth + notedge, yMax + yoffset *squareHeight -notedge, xMax + xoffset *squareWidth - notedge, yMin + yoffset *squareHeight + notedge)


--			     local line = display.newLine(rec.contentBounds.xMin + xposoffset *squareWidth, rec.contentBounds.yMin + yposoffset *squareHeight, rec.contentBounds.xMax + xposoffset *squareWidth, rec.contentBounds.yMax + yposoffset *squareHeight)
--	             local line2 = display.newLine(rec.contentBounds.xMin + xposoffset *squareWidth, rec.contentBounds.yMax + yposoffset *squareHeight, rec.contentBounds.xMax + xposoffset *squareWidth, rec.contentBounds.yMin + yposoffset *squareHeight)
	line.width = 7
	line2.width = 7
	line:setColor(0,255,255)
	line2:setColor(0,255,255)
	
    local crossgroup  = display.newGroup()
    crossgroup:insert(line)
    crossgroup:insert(line2)
    
    return crossgroup

end

function setValues(params)
    squareWidth = params.squareWidth
    squareHeight = params.squareHeight


end