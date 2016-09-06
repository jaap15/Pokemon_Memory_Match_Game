local composer = require( "composer" )
local scene = composer.newScene()

local widget = require("widget")

-- -----------------------------------------------------------------------------------
-- Menu Specific Functions
-- -----------------------------------------------------------------------------------
local function startButtonEvent(event)
	if ("ended" == event.phase) then
		composer.gotoScene("game")
	end
end

-- -----------------------------------------------------------------------------------
-- General Scene Functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local themeStartMp3 = audio.loadStream("audio/Pokemon_Red_Blue_Opening_Theme_Music.mp3")
    audio.play(themeStartMp3)
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local backgroundImage = display.newImage("/images/backdrop.jpg", display.contentCenterX, display.contentCenterY)
	backgroundImage.width = display.pixelWidth
	backgroundImage.height = display.pixelHeight

	print(display.pixelWidth)
	print(display.pixelHeight)
	sceneGroup:insert( backgroundImage )  


    local titleImage = display.newImage("/images/Pokemon_logo.png", display.contentCenterX, display.contentCenterY-(display.contentCenterY/1.3))
    titleImage.xScale = 3
    titleImage.yScale = 3
    sceneGroup:insert( titleImage ) 	

    local title = display.newText("Match Game", display.contentCenterX, display.contentCenterY-(display.contentCenterY/1.75))
    title:setFillColor(255,250,0)
    sceneGroup:insert( title )

    local authors = display.newText("by Daniel and Jairo", display.contentCenterX, display.contentCenterY+(display.contentCenterY/1.2))
	sceneGroup:insert( authors )

	local startButton = widget.newButton({	
		id = "startButton",
		label = "Start",
		width = 250,
		height = 80,
		fontSize = 60,
		defaultFile = "/images/button.png",
		onEvent = startButtonEvent 
	} )	
	startButton.x = display.contentCenterX
	startButton.y = display.contentCenterY+(display.contentCenterY/1.5)
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