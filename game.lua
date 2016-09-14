local composer = require( "composer" )

local scene = composer.newScene()

local widget = require("widget")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

sysOr = system.orientation

-- -----------------------------------------------------------------------------------
-- quizButtonEvent()
-- This function stops the enterFrame listeners and switches us back to the menu scene
-- -----------------------------------------------------------------------------------
local function QuitButtonEvent(event)
    if (event.phase == "ended") then
        audio.stop()
        Runtime:removeEventListener("enterFrame", winner_listener)
        Runtime:removeEventListener("enterFrame", gameTimer)
        composer.gotoScene("menu")
    end
end    

-- -----------------------------------------------------------------------------------
-- drawGame()
-- This function draws the game based on what orientation the phone is
-- -----------------------------------------------------------------------------------
local function drawGame(event)    
    local sysOr = system.orientation
    if (sysOr == "portrait" or sysOr == "portraitUpsideDown") then          
        quitButton.x = display.contentCenterX
        quitButton.y = display.contentCenterY+(display.contentCenterY/1.5)
        timerText.x = display.contentCenterX     
        timerText.y = display.contentCenterY+(display.contentCenterY*0.5)
    elseif (sysOr == "landscapeRight" or sysOr == "landscapeLeft") then
        quitButton.x = display.contentCenterX+(display.contentCenterX/1.5)
        quitButton.y = display.contentCenterY+(display.contentCenterY/1.5)
        timerText.x = display.contentCenterX+(display.contentCenterX/1.5)    
        timerText.y = display.contentCenterY+(display.contentCenterY/2.5)
    end
end

-- -----------------------------------------------------------------------------------
-- exitToMenu()
-- This function stops the music and returns to menu scene
-- -----------------------------------------------------------------------------------
local function exitToMenu(event)
        audio.stop()
        composer.gotoScene("menu")
end

-- -----------------------------------------------------------------------------------
-- winner_listener()
-- This function is called every second and checks to see if all boxes have been checked off
-- If they have, an alert is called and congratulates the player for winning
-- -----------------------------------------------------------------------------------
local function winner_listener(self,event)
    if (winCount == 8) then
        native.showAlert("Winner!", "Congratulations", {"Exit to Menu"}, exitToMenu)
        Runtime:removeEventListener("enterFrame", winner_listener)
        Runtime:removeEventListener("enterFrame", gameTimer)
    end
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- create()
-- This function is the heart of our application, it creates the entire game scene,
-- the buttons, buttuonCovers, quit button, and timer object. It has a functioned
-- defining in it that defines the rules of the matchimg game and calls this function 
-- when a buttonCover is touched. 
-- -----------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Loading and playing the music for game scene
    local themeBattleMp3 = audio.loadStream("audio/Pokemon_Red_Battle_Music.mp3")
    audio.play(themeBattleMp3, {loops = -1})


display.setStatusBar(display.HiddenStatusBar);

-- Defining height and width of scene
_W = display.contentWidth;
_H = display.contentHeight;

local totalButtons = 0

local secondSelect = 0
local checkForMatch = false


x = -20

-- Defining the quit button widget
quitButton = widget.newButton({   
        id = "quitButton",
        label = "Quit",
        width = 250,
        height = 80,
        fontSize = 60,
        defaultFile = "images/button.png",
        onEvent = QuitButtonEvent 
    } ) 

-- Positioning the quit button
if (sysOr == "portrait" or sysOr == "portraitUpsideDown") then     
    quitButton.x = display.contentCenterX
    quitButton.y = display.contentCenterY+(display.contentCenterY/1.5)
elseif (sysOr == "landscapeRight" or sysOr == "landscapeLeft") then
    quitButton.x = display.contentCenterX+(display.contentCenterX/1.5)
    quitButton.y = display.contentCenterY+(display.contentCenterY/1.5)
end
sceneGroup:insert(quitButton)

-- Array of buttons, and buttonCovers
button = {}    
buttonCover = {}    

-- Array of pokemon images
local allPokemons = {}

-- Adding all pokemon to array
for i = 1, 151 do
    allPokemons[i] = i
end

-- Randomizing what pokemon will be used for the matching game
buttonImages = {}
local tmp = 1
for i = 1, 8 do
    selectedPokemon = math.random(1,#allPokemons)

    buttonImages[tmp] = selectedPokemon
    tmp = tmp + 1
    buttonImages[tmp] = selectedPokemon
    tmp = tmp + 1
    table.remove(allPokemons, selectedPokemon)
end
 
tmp = nil
allPokemons = nil

local lastButton = display.newImage("images/Pokeball.png")
lastButton.myName = 1
sceneGroup:insert( lastButton )

-- Game Timer
timerText = display.newText("Time: ", 0, 0, native.systemFont)
timerText:setTextColor(235, 235, 235)

-- Positioning the timer object
if (sysOr == "portrait" or sysOr == "portraitUpsideDown") then   
    timerText.x = display.contentCenterX     
    timerText.y = display.contentCenterY+(display.contentCenterY*0.5)
elseif (sysOr == "landscapeRight" or sysOr == "landscapeLeft") then
    timerText.x = display.contentCenterX+(display.contentCenterX/1.5)    
    timerText.y = display.contentCenterY+(display.contentCenterY/2.5)
end
function displayTime(event)
    timerText.text = "Time: " .. os.time()-t
end
sceneGroup:insert( timerText )

--Set up simple black background
local myRectangle = display.newRect(0, 0, _W, _H)
myRectangle:setFillColor(0, 0, 0)
sceneGroup:insert( myRectangle )

--Notify player if match is found or not
local matchText = display.newText(" ", 0, 0, native.systemFont)
matchText:setTextColor(235, 235, 235)
matchText.x = display.contentCenterX
matchText.y = display.contentCenterY-(display.contentCenterY*0.88)
sceneGroup:insert( matchText )

-- This variable is used to track whether the player has made 8 matches yet
winCount = 0
-- -----------------------------------------------------------------------------------
-- game(object, event)
-- This functions checks to see if button flips match each other or don't match each 
-- other, it will leave the buttons on the screen if they don't match, it will 
-- remove them if they do match
-- -----------------------------------------------------------------------------------
function game(object, event)
    if(event.phase == "began") then             
        if(checkForMatch == false and secondSelect == 0) then
            --Flip over first button
            transition.to(buttonCover[object.number], {time = 500,alpha = 0, xScale =2 , yScale = 2})
            lastButton = object
            checkForMatch = true            
        elseif(checkForMatch == true) then
            if(secondSelect == 0) then
                --Flip over second button
                transition.to(buttonCover[object.number], {time = 500,alpha = 0, xScale =2 , yScale = 2})
                secondSelect = 1;
                --If buttons do not match, flip buttons back over
                if(lastButton.myName ~= object.myName) then
                    matchText.text = "Match Not Found!";
                    timer.performWithDelay(1250, function()                     
                        matchText.text = " ";
                        checkForMatch = false;
                        secondSelect = 0;
                        buttonCover[lastButton.number].alpha = 1
                        buttonCover[object.number].alpha = 1
                    end, 1)                 
                --If buttons DO match, remove buttons
                elseif(lastButton.myName == object.myName) then
                    matchText.text = "Match Found!";
                    timer.performWithDelay(1250, function()                     
                        matchText.text = " ";
                        checkForMatch = false;
                        secondSelect = 0;
                        winCount = winCount + 1
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
    -- Define offsets for button's X positions
    if (sysOr == "portrait" or sysOr == "portraitUpsideDown") then     
        x = x + display.contentWidth/5  
    elseif (sysOr == "landscapeRight" or sysOr == "landscapeLeft") then
        x = x + display.contentWidth/8.3  
    end
    y = 20
     
    for insideCount = 1,4 do -- Number of Rows

    -- Define the offsets for the button's y positions
    if (sysOr == "portrait" or sysOr == "portraitUpsideDown") then   
        y = y + display.contentHeight/9.0
    elseif (sysOr == "landscapeRight" or sysOr == "landscapeLeft") then
        y = y + display.contentHeight/5.0
    end
        --Assign each image a random location on grid
        temp = math.random(1,#buttonImages)
        button[count] = display.newImage("images/Pokemon/" .. buttonImages[temp] .. ".png");     
        sceneGroup:insert( button[count] ) 
        --Position the button   
        button[count].x = x;
        button[count].y = y;  
        button[count].xScale = 1.75
        button[count].yScale = 1.75

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
        sceneGroup:insert( buttonCover[totalButtons] )         
        totalButtons = totalButtons + 1
         
        --Attach listener event to each button
        button[count].touch = game      
        button[count]:addEventListener( "touch", button[count] )
    end
end
end

-- -----------------------------------------------------------------------------------
-- scene:show(event)
-- This function adds event listeners that watch for screen orientation change
-- and one that executes every second
-- -----------------------------------------------------------------------------------
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    t = os.time()

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        Runtime:addEventListener("orientation", drawGame)
        Runtime:addEventListener("enterFrame", winner_listener)
        timer.performWithDelay(1000, displayTime, 0)

    end
end

-- -----------------------------------------------------------------------------------
-- scene:hide(event) 
-- This function removes the scene when we swtich scenes
-- -----------------------------------------------------------------------------------
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene( "game")

    end
end


-- -----------------------------------------------------------------------------------
-- scene:destroy(event)
-- -----------------------------------------------------------------------------------
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