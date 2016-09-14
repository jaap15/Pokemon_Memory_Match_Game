-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Memory Game
-- The composer object allows for the creation of scenes and switching between scenes
-- This composer will be declared in every .lua file
local composer = require("composer")

-- Hiding the Status Bar, Standard Corona coding practice
display.setStatusBar(display.HiddenStatusBar)

-- Only thing that needs to happen in the main function is to push into the menu scene,
-- Once inside the menu scene all graphics, functions, and event listeners are defined
-- and the application only switches between the menu scene and the game scene
composer.gotoScene("menu")