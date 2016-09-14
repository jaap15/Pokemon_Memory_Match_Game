local composer = require( "composer" )

-- Declaration of a new scene, this line of code will be in each composer scene
local scene = composer.newScene()

-- The widget object is used for creating our buttons that switch between scenes
local widget = require("widget")

-- -----------------------------------------------------------------------------------
-- startButtonEvent(event)
-- This function Switches the user from the menu scene to the game scene
-- and stops the menu music
-- -----------------------------------------------------------------------------------
local function startButtonEvent(event)
	if ("ended" == event.phase) then
        audio.stop()
		composer.gotoScene("game")
	end
end

-- -----------------------------------------------------------------------------------
-- drawMenu(event)
-- This function draws the Mnu according to what orientation the phone is in,
-- it also draws the menu according to contentHeight and contentWidth, so it 
-- should be resolution independent
-- -----------------------------------------------------------------------------------
local function drawMenu(event)

    -- Define local variables
    local sysOr = system.orientation

    -- Drawing the menu when its in potrait mode
    if (sysOr == "portrait" or sysOr == "portraitUpsideDown") then  
        -- Changing all the positions of the objects based on portrait mode
        titleImage.x = display.contentCenterX
        titleImage.y = display.contentCenterY-(display.contentCenterY/1.3)
        title.x = display.contentCenterX
        title.y = display.contentCenterY-(display.contentCenterY/1.75)
        authors.x = display.contentCenterX
        authors.y = display.contentCenterY+(display.contentCenterY/1.2)
        startButton.x = display.contentCenterX
        startButton.y = display.contentCenterY+(display.contentCenterY/1.5)
        backgroundImage.x = display.contentCenterX
        backgroundImage.y = display.contentCenterY

        -- Changing the background image to scale to portrait mode
        backgroundImage.width = display.contentWidth
        backgroundImage.height = display.contentHeight 
    -- Drawing the menu when its in landscape mode
    elseif (sysOr == "landscapeRight" or sysOr == "landscapeLeft") then
        -- Changing all the positions of the objects based on landscape mode
        titleImage.x = display.contentCenterX
        titleImage.y = display.contentCenterY-(display.contentCenterY/1.3)
        title.x = display.contentCenterX
        title.y = display.contentCenterY-(display.contentCenterY/2.0)
        authors.x = display.contentCenterX
        authors.y = display.contentCenterY+(display.contentCenterY/1.15)
        startButton.x = display.contentCenterX
        startButton.y = display.contentCenterY+(display.contentCenterY/1.5)
        backgroundImage.x = display.contentCenterX
        backgroundImage.y = display.contentCenterY

        -- Changing the background image to scale to landscape mode
        backgroundImage.width = display.contentWidth
        backgroundImage.height = display.contentHeight
    end
end

-- Each scene is defined by 4 functions: create, show, hide, destroy

-- -----------------------------------------------------------------------------------
-- scene:create(event)
-- This function loads all the assets and files used to create the menu in the 
-- drawMenu() function
-- -----------------------------------------------------------------------------------
function scene:create( event )
    -- Code here runs when the scene is first created but has not yet appeared on screen
    -- Adding the menu scene to the SceneGroup
    local sceneGroup = self.view

    -- Loading and starting the menu music
    local themeStartMp3 = audio.loadStream("audio/Pokemon_Red_Blue_Opening_Theme_Music.mp3")
    audio.play(themeStartMp3, {loops = -1})

    -- Objects to be added to the scene
    backgroundImage = display.newImage("images/backdrop.jpg", display.contentCenterX, display.contentCenterY)
    titleImage = display.newImage("images/Pokemon_logo.png", display.contentCenterX, display.contentCenterY-(display.contentCenterY/1.3))
    title = display.newText("Match Game", display.contentCenterX, display.contentCenterY-(display.contentCenterY/1.75))
    authors = display.newText("by Daniel Burris and Jairo Arreola", display.contentCenterX, display.contentCenterY+(display.contentCenterY/1.2))
    startButton = widget.newButton({    
            id = "startButton",
            label = "Start",    
            width = 250,
            height = 80,
            fontSize = 60,
            defaultFile = "images/button.png",
            onEvent = startButtonEvent 
        } )     


    -- Definitions common to all orientations
    backgroundImage.width = display.pixelWidth
    backgroundImage.height = display.pixelHeight
    
    titleImage.xScale = 3
    titleImage.yScale = 3

    title:setFillColor(255,250,0)

    -- Drawing the menu
    drawMenu()

    -- Adding all objects to scene
    sceneGroup:insert( backgroundImage ) 
    sceneGroup:insert( title )      
    sceneGroup:insert( titleImage )
    sceneGroup:insert( authors )
    sceneGroup:insert(startButton)  
end


-- -----------------------------------------------------------------------------------
-- scene:show(event)
-- This function only listens for when the phone is turned and calls the drawMenu() 
-- function
-- -----------------------------------------------------------------------------------
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        Runtime:addEventListener("orientation", drawMenu)

    end
end


-- -----------------------------------------------------------------------------------
-- scene:hide(event)
-- This function just removes the scene when we are switching scenes
-- -----------------------------------------------------------------------------------
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene( "menu")
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

return scene