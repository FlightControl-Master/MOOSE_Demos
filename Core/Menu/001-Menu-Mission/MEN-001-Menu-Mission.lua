---
-- Author: kaltokri
-- Created: 16.03.2024
-- Contributors: -
-- Modified: -
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Menu.html
--
-- # Description:
--
-- Very simple example of the MENU_MISSION class.
-- We define a top menu entry, a sub menu entry and to menu commands.
-- Both commands call the same function, but with different arguments.

-- # Guide:
--
-- 1. Start the mission and enter as GAME MASTER.
-- 2. Wait for "loaded successfully" message.
-- 3. Open menu by pressing #
-- 4. Choose F10. Other...
-- 5. Select F1. Menu for all players...
-- 6. Select F1. Sub menu 1...
-- 7. Select Cmd1
-- 8. Repeat the same for Cmd2


-- Example function
local function execMenuCmd( name )
  MESSAGE:New( "Menu entry " .. name .. " selected", 25, "INFO" ):ToAll()
end

local MenuTop = MENU_MISSION:New( "Menu for all players" )
local MenuSub1 = MENU_MISSION:New( "Sub menu 1", MenuTop )
MENU_MISSION_COMMAND:New( "Cmd1", MenuSub1, execMenuCmd, "Cmd1" )
MENU_MISSION_COMMAND:New( "Cmd2", MenuSub1, execMenuCmd, "Cmd2" )

MESSAGE:New( "Moose Framework and Mission script loaded successfully", 25, "INFO" ):ToAll():ToLog()
