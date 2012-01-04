local ui = require("ui")
local boardwidth = 8
local boardheight = 11 -- should be 12 but we use 1 for undo row.

local maxX = 0
local maxY = 0
local minX = 0
local minY = 0
local displayboardheight = display.contentHeight-2 - (display.contentHeight / boardheight+1)
local squareHeight = (displayboardheight/boardheight)
local squareWidth = (display.contentWidth-2)/boardwidth
allcc = 1
tableAll = {}   -- This holds all the squares.
tableGameBoardPlacement = {}  -- This holds the array where the xroos or circle is placed
allcrossandcircles = {}  -- This holds all the xrosss and cirels The actully drawings.
turnphase =1 
currentturnxross = nil
currentturncircle = nil

scorebord = nil
restartbutton = nil
undobutton = nil
crossScore = 0
circleScore = 0
playerwontext = nil
currentscoreText = nil
crossScoreText = nil
circleScoreText = nil

tileText = nil
startButton = nil

gameboardgroup = nil -- This is the group that contains all cross and circles. So that we can move them around
lasteventid = nil
lastsquareid = nil
startsquareid = nil

lastpreviewdraw = nil
lastplacedforundo = nil

xposoffset = 0
yposoffset = 0

delaytime = 500
boardlocked = 0 -- Flag to indicate that someone just placed. and to
                -- avoid that removing a finger accidental places a new xross or circle
lasttimerid = nil


local function checkWin(i, j)

    local inarow = 1
    player = tableGameBoardPlacement[i][j]
    horozontalWinR = 1
    horozontalWinL = 1
    horozontalWin = 1
    verWinD = 1
    verWinU = 1
    verticalwin = 1
    digWinLU = 1
    digWinLD = 1
    digWinRU = 1
    digWinRD = 1
    
    digWinLTRD = 1 -- Left Top, Rigth down
    digWinLDRT = 1 -- Left Down Right top


                
    for index = 1, 4,1 do 
        if tableGameBoardPlacement[i+index] ~= nil then
            if tableGameBoardPlacement[i+index][j] ~= player then 
                horozontalWinR = 0
            elseif horozontalWinR == 1 then
                horozontalWin = horozontalWin +1 
            end
            if tableGameBoardPlacement[i+index][j-index] ~= player then 
                digWinRU = 0
            elseif digWinRU == 1 then
                digWinLDRT  = digWinLDRT +1               
            end
            
            if tableGameBoardPlacement[i+index][j+index] ~= player then 
                digWinRD = 0
            elseif digWinRD == 1 then
                digWinLTRD = digWinLTRD +1
            end
        else
           
            horozontalWinR = 0
            digWinRD = 0
            digWinRU = 0
        end
        
        if tableGameBoardPlacement[i-index] ~= nil then
            if tableGameBoardPlacement[i-index][j] ~= player then 
                horozontalWinL = 0
            elseif horozontalWinL == 1 then 
                horozontalWin = horozontalWin +1
            end
            if tableGameBoardPlacement[i-index][j-index] ~= player then 
                digWinLU = 0
            elseif digWinLU == 1 then
                digWinLTRD = digWinLTRD +1
            end
            if tableGameBoardPlacement[i-index][j+index] ~= player then 
                digWinLD = 0
            elseif digWinLD == 1 then
                digWinLDRT = digWinLDRT +1
            end
        else
            horozontalWinL = 0
            digWinLD = 0
            digWinLU = 0
        end
        
        if tableGameBoardPlacement[i][j+index] ~= player then 
            verWinD = 0
        elseif  verWinD == 1 then
            verticalwin = verticalwin +1 
        end
        if tableGameBoardPlacement[i][j-index] ~= player then 
            verWinU = 0
         elseif  verWinU == 1 then
            verticalwin = verticalwin +1 
        end
    end

	print ("checkWin")
	print (horozontalWin)
	print (verticalwin)
	print(digWinLTRD)
	print (digWinLDRT)


    
    if horozontalWin > 4 or verticalwin > 4 or digWinLTRD > 4 or digWinLDRT > 4 then
        print("Now return playter since he won")
        return player
    end

    return 0
end

local function gameWon(player)

    local i = 0
    while i < boardwidth do
	    local j =0
	    while j < boardheight do
	        tableAll[i][j][1].isVisible = false
	        j = j +1
	    end
	    i = i +1
	end
	for index = 1, allcc-1, 1 do 
        local parent = allcrossandcircles[index].parent
        parent:remove(allcrossandcircles[index])
        allcrossandcircles[index] = nil
        allcc =1
             
    end
    currentturnxross.isVisible = false
	currentturncircle.isVisible = false
    titleText.isVisible = true
	--scorebord.isVisible =     true
    restartbutton.isVisible = true
    undobutton.isVisible = false
    if player.player == 1 then
	         
	    playerwontext = display.newText("Circle Wins!!", 100, 100, native.systemFont, 72)
        playerwontext:setTextColor(255, 255, 255)
        circleScore = circleScore +1 
	elseif player.player == 2 then  
	     playerwontext = display.newText("Cross Wins!!", 100, 100, native.systemFont, 72)
         playerwontext:setTextColor(255, 255, 255)
         crossScore = crossScore +1
    end
    local textscore = string.format("Current score")
    currentscoreText = display.newText(textscore, 100, 700, native.systemFont, 48)
    local text1 = string.format("Cross:%d", crossScore)
    crossScoreText = display.newText(text1, 100, 750, native.systemFont, 48)
    local text2 = string.format("Circle:%d", circleScore)
    circleScoreText = display.newText(text2, 100, 800, native.systemFont, 48)

end

local function updategameboardmaxs(realxpos, realypos)

    if turnphase  == 1 then
       minX = realxpos
       maxX = realxpos
       minY = realypos
       maxY = realypos
       return 0
    end
    if realxpos > maxX then
	    maxX = realxpos
	end
	if realxpos < minX  then
	    minX = realxpos
	end
	if realypos > maxY then
	    maxY = realypos
	end
	if realypos < minY then
       minY = realypos
   end
end

local function drawCirlce(x, y, xoffset, yoffset)
   local circle = display.newCircle(x + xoffset *squareWidth, y+ yoffset *squareHeight, squareWidth/3)
   circle:setFillColor(0,0,0,0)
   circle.strokeWidth = 7
   circle:setStrokeColor(255, 255,0)
   return circle
end

local function drawCross(xMin, yMin, xMax, yMax, xoffset, yoffset)
    local notedge = 15
    
    print(math.ceil(xMin + xoffset *squareWidth + notedge))
    print(math.ceil(yMin + yoffset *squareHeight +notedge))
    print(math.ceil(xMax + xposoffset *squareWidth -notedge))
    print(math.ceil(yMax + yposoffset *squareHeight -notedge))
    



    local line = display.newLine(math.ceil(xMin + xoffset *squareWidth + notedge), math.ceil(yMin + yoffset *squareHeight +notedge), math.ceil(xMax + xoffset *squareWidth -notedge), math.ceil(yMax + yoffset *squareHeight -notedge))
    local line2 = display.newLine(xMin + xoffset *squareWidth + notedge, yMax + yoffset *squareHeight -notedge, xMax + xoffset *squareWidth - notedge, yMin + yoffset *squareHeight + notedge)


--			     local line = display.newLine(rec.contentBounds.xMin + xposoffset *squareWidth, rec.contentBounds.yMin + yposoffset *squareHeight, rec.contentBounds.xMax + xposoffset *squareWidth, rec.contentBounds.yMax + yposoffset *squareHeight)
--	             local line2 = display.newLine(rec.contentBounds.xMin + xposoffset *squareWidth, rec.contentBounds.yMax + yposoffset *squareHeight, rec.contentBounds.xMax + xposoffset *squareWidth, rec.contentBounds.yMin + yposoffset *squareHeight)
	line.width = 7
	line2.width = 7
	line:setColor(255,0,0)
	line2:setColor(255,0,0)
	
    local crossgroup  = display.newGroup()
    crossgroup:insert(line)
    crossgroup:insert(line2)
    
    return crossgroup

end


local function resetTimer()
    print("Board no longer locked")
    boardlocked = 0

end 

    

local function drawInSquare(event)

    print (event.phase)
    if "cancelled" == event.phase then
        if (lastpreviewdraw ~= nil) then
	        local lastparent = lastpreviewdraw.parent
	        lastparent:remove(lastpreviewdraw)
	        lastpreviewdraw = nil
	    end
    end
    if "began" == event.phase and boardlocked == 0 then
        local i =0
	    local x
	    local y
	    local rec
	    print("began")
	    print(event)
	    x = event.target.xPos
        y = event.target.yPos
        print(x)
        print(y)
        rec = event.target
        print(rec.x)
        print(rec.y)
	    local realxpos = x+xposoffset
	    local realypos = y+yposoffset
	    local tp = turnphase %2 +1;
        print("Began end")

	        
	    if (tableGameBoardPlacement[realxpos] == nil) then
     	    if tp == 1 then
	            lastpreviewdraw = drawCirlce(rec.x, rec.y, xposoffset, yposoffset)
	        else
	            lastpreviewdraw = drawCross(rec.contentBounds.xMin, rec.contentBounds.yMin, rec.contentBounds.xMax, rec.contentBounds.yMax , xposoffset, yposoffset)
	        end
	    elseif (tableGameBoardPlacement[realxpos][realypos] == nil) then
	        if tp == 1 then
	            lastpreviewdraw = drawCirlce(rec.x, rec.y, xposoffset, yposoffset)
	        else
	            lastpreviewdraw = drawCross(rec.contentBounds.xMin, rec.contentBounds.yMin, rec.contentBounds.xMax, rec.contentBounds.yMax , xposoffset, yposoffset)
	        end
	    end
	    if lastpreviewdraw ~= nil then
	        gameboardgroup:insert(lastpreviewdraw)
	    end
    end
    

    
	if "ended" == event.phase and event.id ~= lasteventid and boardlocked == 0 then	
	    if (lastpreviewdraw ~= nil) then
	        local lastparent = lastpreviewdraw.parent
	        lastparent:remove(lastpreviewdraw)
	        lastpreviewdraw = nil
	    end
	    
	    print("ended")
	    
	    local i =0
	    local x
	    local y
	    local rec
	     x = event.target.xPos
         y = event.target.yPos
         rec = event.target
	     local realxpos = x+xposoffset
	     local realypos = y+yposoffset
    
         print(x)
         print(y)
         print(rec.x)
         print(rec.y)
         print("ended end")

	     if (tableGameBoardPlacement[realxpos] == nil) then
	         tableGameBoardPlacement[realxpos] = {}
	     end
	     
	     if (tableGameBoardPlacement[realxpos][realypos] == nil) then
	         local tp = turnphase %2 +1
	         tableGameBoardPlacement[realxpos][realypos] = tp;
	         lastplacedforundo = nil
	         lastplacedforundo = {}
	         lastplacedforundo[0] = realxpos
	         lastplacedforundo[1] = realypos
	         updategameboardmaxs(realxpos, realypos)
	         
	         if tp == 1 then
	             local circle = drawCirlce(rec.x, rec.y, xposoffset, yposoffset)
	             allcrossandcircles[allcc] = circle
	             gameboardgroup:insert(circle)
	             lastplacedforundo[2] = circle
	             currentturnxross.isVisible = true
				currentturncircle.isVisible = false
	             
	         else
	             local cross = drawCross(rec.contentBounds.xMin, rec.contentBounds.yMin, rec.contentBounds.xMax, rec.contentBounds.yMax , xposoffset, yposoffset)
			     gameboardgroup:insert(cross)
                 allcrossandcircles[allcc] = cross
                 lastplacedforundo[2] = cross
                 currentturnxross.isVisible = false
				currentturncircle.isVisible = true
   			 end
	         
	          lastplacedforundo[3] = allcc
	          allcc = allcc +1
	          
	         turnphase = turnphase +1
	     end
	     local playerwon = checkWin(realxpos,realypos)
	     if playerwon > 0 then
	         gameWon{player=playerwon}
	     end
	     lasttimerid = timer.performWithDelay(delaytime, resetTimer) 
   	     boardlocked = 1

	end    
--    myRectangle.setFillColor(255,255,255)
end
local function sign(value)
    if value >= 0 then
        return 1
    end
    return -1


end

local function newCord(max, min, start, move,size)
   move = move * -1
   l1 = min - (start+2)
   l2 = max - (start+size-3)
   L1 = (l1 + (l1 *	sign(l1) * sign(move)) )/2
   L2 = (l2 + (l2 * sign(l2) * sign(move)) )/2
   newdelta = sign(move) * math.min(math.abs(move) , math.max(math.abs(L1), math.abs(L2)))
   return newdelta * -1
end


local function moveGameboard(event)
    if event.phase == "moved" then
        if event.id == lasteventid then
            if lastsquareid ~= event.target then
                if (lastpreviewdraw ~= nil ) then
                    local lastparent = lastpreviewdraw.parent
	                lastparent:remove(lastpreviewdraw)
	                lastpreviewdraw = nil
	            end
            	lastsquareid = event.target
            	movex = (lastsquareid.xPos - startsquareid.xPos)
            	movey = (lastsquareid.yPos - startsquareid.yPos)
            	deltax = newCord(maxX, minX, gameboardgroup.xposoffsetstart, movex, boardwidth)
            	deltay = newCord(maxY, minY, gameboardgroup.yposoffsetstart, movey, boardheight)
            	xposoffset = gameboardgroup.xposoffsetstart - deltax
              	gameboardgroup.x = gameboardgroup.xstarted + deltax * squareWidth
           	    yposoffset = gameboardgroup.yposoffsetstart - deltay 
        	    gameboardgroup.y = gameboardgroup.ystarted  + deltay * squareHeight 

            end                
        else 
            lasteventid = event.id
            lastsquareid = event.target
            startsquareid = event.target
            gameboardgroup.xstarted = gameboardgroup.x
            gameboardgroup.ystarted = gameboardgroup.y
            gameboardgroup.xposoffsetstart = xposoffset
            gameboardgroup.yposoffsetstart = yposoffset
         end
    elseif event.phase == "ended"  and lasttimerid ~= nil then 
    
        timer.cancel(lasttimerid)
    	timer.performWithDelay(delaytime, resetTimer) 
    	boardlocked = 1 

    	
    else
        lastsquareid = nil
        startsquareid = nil
    
    end
    
end

local function undoLastMove(event)
   if event.phase == "ended" and lastplacedforundo ~= nil then
      print("Undo")
      tableGameBoardPlacement[ lastplacedforundo[0]][lastplacedforundo[1]] = nil
      local parent = lastplacedforundo[2].parent
      parent:remove(lastplacedforundo[2])
      allcc = lastplacedforundo[3]   
      allcrossandcircles[allcc] = nil
      lastplacedforundo = nil
      turnphase = turnphase +1 -- change to next player (same as preveus)
      local tp = turnphase %2 
      if (tp == 1) then
         currentturnxross.isVisible = true
         currentturncircle.isVisible = false
      else
         currentturnxross.isVisible = false
         currentturncircle.isVisible = true
      end
   end
end
local function newGame()
	tableGameBoardPlacement = nil
	tableGameBoardPlacement = {}
	xposoffset = 0
	yposoffset = 0
	gameboardgroup.x = 0
	gameboardgroup.y = 0
	lastplacedforunto = nil
	turnphase  =1 
	currentturnxross.isVisible = true
	currentturncircle.isVisible = false
	titleText.isVisible = false
	undobutton.isVisible = true
	
    local i = 0
    while i < boardwidth do
		local j =0
		while j < boardheight do
			tableAll[i][j][1].isVisible = true
			j = j +1
		end
		i = i +1
	end
end


local function startGame(event)
	if "ended" == event.phase then	
		startbutton.isVisible = false
		newGame()
	end

end

local function restartGame(event)
	if "ended" == event.phase then	
	    print (allcc)
	    
	   
     	local parent = playerwontext.parent
     	parent:remove(playerwontext)
     	parent:remove(circleScoreText) -- should be same parent
     	parent:remove(crossScoreText)
     	parent:remove(currentscoreText)
     	circleScoreText = nil
     	crossScoreText = nil
     	playerwontext = nil
     	currentscoreText = nil
     	
     	
        --scorebord.isVisible = false
        restartbutton.isVisible = false
        
        newGame()
        
        
    end
end

function drawSquare(x1,y1,x2,y2, i , j)
    local myRectangle = display.newRect(x1, y1, x2, y2)
    myRectangle.strokeWidth = 2
    myRectangle:setStrokeColor(0, 0, 0)
    myRectangle:setFillColor(0, 0, 0,40)
    myRectangle:addEventListener("touch", drawInSquare)
    myRectangle:addEventListener("touch", moveGameboard)
    myRectangle.xPos = i
    myRectangle.yPos = j
    if tableAll[i] == nil then 
    	
    	tableAll[i] = {}
    end
    tableAll[i][j] = {}
    tableAll[i][j][1] = myRectangle
    tableAll[i][j][1].isVisible = false
    tableAll[i][j][2] = 0
    
end

local function testfunction(event)
   if (event.phase == "ended") then
       if (lastpreviewdraw ~= nil ) then
           local lastparent = lastpreviewdraw.parent
	       lastparent:remove(lastpreviewdraw)
    	   lastpreviewdraw = nil
        end
    end

end

print ("STart")

display.setStatusBar(display.HiddenStatusBar)
myImage = display.newImage("background4.png", true)
for i = 0, boardwidth-1, 1 do
	--local x1 = 1+i*((display.contentWidth-2)/(boardwidth))
	local x1 = 1 + i* squareWidth
	for j = 0, boardheight-1, 1 do
	    --local y1 = 1+j*((display.contentHeight-2)/(boardheight))
	    local y1 = 1+j*squareHeight
	    
	    drawSquare(x1, y1, squareWidth, squareHeight, i, j)
	end
end
--scorebord = display.newRect(0,0, display.contentWidth, display.contentHeight)
--scorebord:setFillColor(0,0,0)

startbutton = ui.newButton{default = "startbuttonRed.png", over = "startbuttonRedOver.png", id = "startbutton", text= "New Local Game", size = 40, emboss = true}
startbutton.x = display.contentWidth /2
startbutton.y = display.contentHeight /2
startbutton:addEventListener("touch", startGame)

--local titletext1 = string.format("Fem I Rad")
--titleText = display.newText(titletext1, 100, 140, native.Zapfino, 32)
titleText = display.newImage("Title.png", 0, 175, true)


restartbutton = ui.newButton{default = "buttonRed.png", over = "buttonRedOver.png", id = "undobutton", text= "Restart", size = 40, emboss = true}
restartbutton.x = display.contentWidth /2
restartbutton.y = display.contentHeight /2
restartbutton:addEventListener("touch", restartGame)
--scorebord.isVisible = false
restartbutton.isVisible = false
gameboardgroup  = display.newGroup()
local bottomimagetest = display.newImage("bgtest2.png", 0,(boardheight) * squareHeight, true) 
currentturnxross = drawCross(30, (boardheight) * squareHeight,squareWidth+30, (boardheight +1 )*squareHeight, 0, 0)
currentturncircle =drawCirlce(squareWidth/2 +30, (boardheight) * squareHeight +squareHeight/2, 0, 0)
currentturnxross.isVisible = false
currentturncircle.isVisible = false

--local undobutton = display.newRoundedRect(5, displayboardheight+6, display.contentWidth-10, display.contentHeight-displayboardheight-6, 10)
--local undobuttonlabel = display.newText("UNDO", undobutton.x-80, undobutton.y -30, native.systemFont, 60)
--undobutton:setFillColor(0,0,0)
undobutton = ui.newButton{default = "buttonRed.png", over = "buttonRedOver.png", id = "undobutton", text= "UNDO", size = 40, emboss = true}
undobutton.x = display.contentWidth/2
undobutton.y = displayboardheight+ squareHeight/2
undobutton:addEventListener("touch", undoLastMove)
undobutton.isVisible = false
Runtime:addEventListener("touch", testfunction)