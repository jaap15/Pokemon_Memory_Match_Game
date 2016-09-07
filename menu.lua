local composer = require( "composer" )
local scene = composer.newScene()

local widget = require("widget")

-- -----------------------------------------------------------------------------------
-- Menu Specific Functions
-- -----------------------------------------------------------------------------------
local function startButtonEvent(event)
	if ("ended" == event.phase) then
        audio.fadeOut(themeStartMp3)
		composer.gotoScene("game")
	end
end

local function drawMenu(event)

    -- Define local variables
    local sysOr = system.orientation
    local themeStartMp3 = audio.loadStream("audio/Pokemon_Red_Blue_Opening_Theme_Music.mp3")
    audio.play(themeStartMp3)

    if (sysOr == "portrait" or sysOr == "portraitUpsideDown") then  
        -- Changing Object Position
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
        backgroundImage.width = display.pixelWidth
        backgroundImage.height = display.pixelHeight 

        startButton.x = display.contentCenterX
        startButton.y = display.contentCenterY+(display.contentCenterY/1.5) 
    elseif (sysOr == "landscapeRight" or sysOr == "landscapeLeft") then
        -- Changing Object Position
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
        backgroundImage.width = display.pixelHeight
        backgroundImage.height = display.pixelWidth 
    end
end


-- -----------------------------------------------------------------------------------
-- General Scene Functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --local themeStartMp3 = audio.loadStream("audio/Pokemon_Red_Blue_Opening_Theme_Music.mp3")
    --audio.play(themeStartMp3)
    sceneGroup = self.view

    -- Objects to be added to the scene
    backgroundImage = display.newImage("images/backdrop.jpg", display.contentCenterX, display.contentCenterY)
    titleImage = display.newImage("images/Pokemon_logo.png", display.contentCenterX, display.contentCenterY-(display.contentCenterY/1.3))
    title = display.newText("Match Game", display.contentCenterX, display.contentCenterY-(display.contentCenterY/1.75))
    authors = display.newText("by Daniel and Jairo", display.contentCenterX, display.contentCenterY+(display.contentCenterY/1.2))
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

    drawMenu()

    -- Adding all objects to scene
    sceneGroup:insert( backgroundImage ) 
    sceneGroup:insert( title )      
    sceneGroup:insert( titleImage )
    sceneGroup:insert( authors )
    sceneGroup:insert(startButton)  


end


-- show()
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