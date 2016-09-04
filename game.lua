local composer = require( "composer" )

local scene = composer.newScene()

local widget = require("widget")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function PlayButtonEvent(event)
    if ("ended" == event.phase) then
        composer.gotoScene("menu")
    end
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen


display.setStatusBar(display.HiddenStatusBar);

_W = display.contentWidth;
_H = display.contentHeight;

print(_W)
print(_H)

local totalButtons = 0

local secondSelect = 0
local checkForMatch = false

x = -20

local quitButton = widget.newButton({   
        id = "quitButton",
        label = "Quit",
        width = 250,
        height = 80,
        fontSize = 60,
        defaultFile = "/images/button.png",
        onEvent = QuitButtonEvent 
    } ) 
    quitButton.x = display.contentCenterX
    quitButton.y = display.contentCenterY+(display.contentCenterY/1.5)
    sceneGroup:insert(quitButton)

local button = {}    
local buttonCover = {}    
local buttonImages = {1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8}

local lastButton = display.newImage("images/Pokeball.png")
lastButton.myName = 1


--Set up simple off-white background
local myRectangle = display.newRect(0, 0, _W, _H)
myRectangle:setFillColor(0, 0, 0)

--Notify player if match is found or not
local matchText = display.newText(" ", 0, 0, native.systemFont)
matchText:setTextColor(235, 235, 235)
matchText.x = display.contentCenterX
matchText.y = display.contentCenterY-(display.contentCenterY*0.88)

--Set up game function
function game(object, event)
    if(event.phase == "began") then             
        if(checkForMatch == false and secondSelect == 0) then
            --Flip over first button
            buttonCover[object.number].isVisible = false;
            lastButton = object
            checkForMatch = true            
        elseif(checkForMatch == true) then
            if(secondSelect == 0) then
                --Flip over second button
                buttonCover[object.number].isVisible = false;
                secondSelect = 1;
                --If buttons do not match, flip buttons back over
                if(lastButton.myName ~= object.myName) then
                    matchText.text = "Match Not Found!";
                    timer.performWithDelay(1250, function()                     
                        matchText.text = " ";
                        checkForMatch = false;
                        secondSelect = 0;
                        buttonCover[lastButton.number].isVisible = true;
                        buttonCover[object.number].isVisible = true;
                    end, 1)                 
                --If buttons DO match, remove buttons
                elseif(lastButton.myName == object.myName) then
                    matchText.text = "Match Found!";
                    timer.performWithDelay(1250, function()                     
                        matchText.text = " ";
                        checkForMatch = false;
                        secondSelect = 0;
                        lastButton:removeSelf();
                        object:removeSelf();
                        buttonCover[lastButton.number]:removeSelf();
                        buttonCover[object.number]:removeSelf();
                    end, 1) 
                end             
            end         
        end
    end
end


--Place buttons on screen
for count = 1,4 do -- Number of Columns
    x = x + display.contentWidth/5
    y = 20
     
    for insideCount = 1,4 do -- Number of Rows
        y = y + display.contentHeight/8
         
        --Assign each image a random location on grid
        temp = math.random(1,#buttonImages)
        button[count] = display.newImage("images/" .. buttonImages[temp] .. ".ico");             
        --Position the button
        button[count].x = x;
        button[count].y = y;        
        button[count].xScale = 2
        button[count].yScale = 2
         
        --Give each a button a name
        button[count].myName = buttonImages[temp]
        button[count].number = totalButtons
         
        --Remove button from buttonImages table
        table.remove(buttonImages, temp)
         
        --Set a cover to hide the button image      
        buttonCover[totalButtons] = display.newImage("images/Pokemon-64.png");
        buttonCover[totalButtons].xScale = 2
        buttonCover[totalButtons].yScale = 2
        buttonCover[totalButtons].x = x; buttonCover[totalButtons].y = y;
        totalButtons = totalButtons + 1
         
        --Attach listener event to each button
        button[count].touch = game      
        button[count]:addEventListener( "touch", button[count] )
    end
end
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene