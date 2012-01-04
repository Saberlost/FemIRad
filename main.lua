local ui = require("ui")
local gameboard = require("gameboard")
local GBO = nil -- Game board Object

local boardwidth = 8
local boardheight = 11 -- should be 12 but we use 1 for undo row.

local displayboardheight = display.contentHeight-2 - (display.contentHeight / boardheight+1)
local squareHeight = (displayboardheight/boardheight)
local squareWidth = (display.contentWidth-2)/boardwidth

local gamerunning = 0


scorebord = nil
restartbutton = nil

crossScore = 0
circleScore = 0
playerwontext = nil
currentscoreText = nil
crossScoreText = nil
circleScoreText = nil

tileText = nil
startButton = nil







local function gameWon(player)


  
    titleText.isVisible = true
	--scorebord.isVisible =     true
    restartbutton.isVisible = true
    
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




local function newGame()
	titleText.isVisible = false
	
	gameboard.newGame()
	gamerunning = 1
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


local function checkAnyoneWin(event)
   if "ended" == event.phase and gamerunning == 1 then	
     print ("Did anyone win")
     local winner = gameboard.didAnyoneWin() 
     print("The winner is %s", winner)
     if (winner> 0) then
         gameWon{player=winner}
         gamerunning = 0
     end
   end
end



print ("STart")

display.setStatusBar(display.HiddenStatusBar)
myImage = display.newImage("background4.png", true)
--myImage = display.newImage("Bigstock_7108049.jpg", true)
--myImage = display.newImage("Bigstock_908845.jpg", true)
--myImage = display.newImage("Bigstock_11951336.jpg", true)
--myImage = display.newImage("backfire2.png", true)





gameboard.setValues{boardwidth=boardwidth, boardheight=boardheight, squareHeight=squareHeight, squareWidth = squareWidth,  displayboardheight = displayboardheight }

GBO = gameboard.init()
Runtime:addEventListener("touch", checkAnyoneWin)
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



--local undobutton = display.newRoundedRect(5, displayboardheight+6, display.contentWidth-10, display.contentHeight-displayboardheight-6, 10)
--local undobuttonlabel = display.newText("UNDO", undobutton.x-80, undobutton.y -30, native.systemFont, 60)
--undobutton:setFillColor(0,0,0)
