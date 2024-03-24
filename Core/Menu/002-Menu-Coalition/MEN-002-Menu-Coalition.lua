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
-- Very simple example of the MENU_COALITION class.
-- We define two top menu entries with the name "Mission phases". One for each coalition (red & blue).
-- Also we add a COMMAND for each menu, which calls the same function.
-- Note the different names of the menu items.
-- Also we add one entry at the top level for coalition.side.BLUE.

-- # Guide:
--
-- 1.  Start the mission and choose coalition Red.
-- 2.  Enter as GAME MASTER.
-- 3.  Wait for "loaded successfully" message.
-- 4.  Open menu by pressing #
-- 5.  Choose F10. Other...
-- 6.  Select F1. Mission phases...
-- 7.  Select F1. Start attack and see message.
-- 8.  Switch to coalition Blue.
-- 9.  Open menu by pressing #
-- 10. Choose F10. Other...
-- 11. Select F1. Mission phases...
-- 12. Select F1. Start counter attack and see message.
-- 13. Open menu by pressing # and select F10. Other...
-- 14. See entry F2. Start attack of Allies and select it.
-- 15. See the message.


-- Example function
local function execMenuCmd( side )
  MESSAGE:New( "The " .. side .. " side will start their attack phase!", 25, "INFO" ):ToAll()
end

local menuRed = MENU_COALITION:New( coalition.side.RED, "Mission phases" )
MENU_COALITION_COMMAND:New( coalition.side.RED, "Start attack", menuRed , execMenuCmd, "red" )

local menuBlue = MENU_COALITION:New( coalition.side.BLUE, "Mission phases" )
MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Start counter attack", menuBlue , execMenuCmd, "blue" )

-- This is an example on how to place a COMMAND at top level of the menu. The third parameter must be nil.
MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Start attack of Allies", nil , execMenuCmd, "purple" )

MESSAGE:New( "Mission script loaded successfully", 25, "INFO" ):ToAll():ToLog()
