-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
display.setStatusBar(display.HiddenStatusBar);

_W = display.contentWidth;
_H = display.contentHeight;

local totalButtons = 0

local secondSelect = 0
local checkForMatch = false

x = -20

local button = {}
local buttonCover = {}
local buttonImages = {1,1, 2,2, 3,3, 4,4, 5,5, 6,6}

local lastButton = display.newImage("images/Pokemon-64.png");
lastButton.myName = 1;

--Set up simple off-white background
local myRectangle = display.newRect(0, 0, _W, _H)
myRectangle:setFillColor(0, 0, 0)

--Notify player if match is found or not
local matchText = display.newText(" ", 0, 0, native.systemFont, 26)
matchText:setReferencePoint(display.CenterReferencePoint)
matchText:setTextColor(235, 235, 235)
matchText.x = _W/2

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
for count = 1,3 do
    x = x + 90
    y = 20
     
    for insideCount = 1,4 do
        y = y + 90
         
        --Assign each image a random location on grid
        temp = math.random(1,#buttonImages)
        button[count] = display.newImage("images/" .. buttonImages[temp] .. ".ico");             
        --Position the button
        button[count].x = x;
        button[count].y = y;        
         
        --Give each a button a name
        button[count].myName = buttonImages[temp]
        button[count].number = totalButtons
         
        --Remove button from buttonImages table
        table.remove(buttonImages, temp)
         
--Set a cover to hide the button image      
        buttonCover[totalButtons] = display.newImage("images/Pokemon-64.png");
        buttonCover[totalButtons].x = x; buttonCover[totalButtons].y = y;
        totalButtons = totalButtons + 1
         
        --Attach listener event to each button
        button[count].touch = game      
        button[count]:addEventListener( "touch", button[count] )
    end
end