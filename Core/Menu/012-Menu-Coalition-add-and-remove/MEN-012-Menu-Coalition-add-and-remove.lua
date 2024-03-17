---
-- Author: FlightControl
-- Created: 20.10.2018
-- Contributors: kaltokri
-- Modified: 17.03.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Menu.html
--
-- # Description:
--
-- This demo creates a menu structure for the planes within the red coalition.
-- This time you can add and remove menu entries dynamic.
-- We use other menu entries to add and remove the menu entry "Show Status".
-- But this is only for simplification. You can change them in your mission code depending on the situation.
--
-- # Guide:
--
-- 1.  Start the mission and choose Plane 1.
-- 2.  Wait for "loaded successfully" message.
-- 3.  Open menu by pressing #
-- 4.  Choose F10. Other...
-- 5.  Select F1. Manage Menus...
-- 6.  Select F1. Add Status Menu.
-- 7.  Open menu by pressing # again.
-- 8.  Choose F10. Other...
-- 9.  Select new entry F3. Status of Planes... and F1. Show Status.
-- 10. See the message.
-- 11. Switxh to Plane 2
-- 12. Open menu by pressing #
-- 13. Choose F10. Other...
-- 14. The menu entry F2. Status of Planes... is available
--     NOTE: The order of the menu entries may vary!
-- 15. Select F2. Status of Planes... and F1. Show Status.
-- 16. See the message again.
-- 17. Open menu by pressing #
-- 18. Choose F10. Other...
-- 19. Select F1. Manage Menus...
-- 20. Choose F2. Remove Status Menu
-- 21. Open the menu and check the menu entry Status of Planes is gone.
-- 22. Switch back to Planre 1 and check that the menu entry is also removed.

-- Find and save client object
local Plane1 = CLIENT:FindByName( "Plane 1" )
local Plane2 = CLIENT:FindByName( "Plane 2" )

-- This would create a menu for the red coalition under the main DCS "Others" menu.
local MenuCoalitionRed = MENU_COALITION:New( coalition.side.RED, "Manage Menus" )

-- We define the variable here, so we can use them in the functions, but the status is saved on mission script level.
local MenuStatus -- Menu#MENU_COALITION

-- A simple function to show a status text.
local function ShowStatus( StatusText, TextToCoalition )
  MESSAGE:New( TextToCoalition, 15 ):ToRed()
  Plane1:Message( StatusText, 15 )
  Plane2:Message( StatusText, 15 )
end

-- This function creates a menu entry for the red coalition to show a status message.
local function AddStatusMenu()
  MenuStatus = MENU_COALITION:New( coalition.side.RED, "Status of Planes" )
  local MenuStatusShow = MENU_COALITION_COMMAND:New( coalition.side.RED, "Show Status", MenuStatus, ShowStatus, "Status of planes is ok!", "Message to Red Coalition" )
end

-- This function removes the menu entry for the red coalition to show a status message.
local function RemoveStatusMenu()
  MenuStatus:Remove()
end

-- Add two entries to add and remove another
local MenuAdd    = MENU_COALITION_COMMAND:New( coalition.side.RED, "Add Status Menu", MenuCoalitionRed, AddStatusMenu )
local MenuRemove = MENU_COALITION_COMMAND:New( coalition.side.RED, "Remove Status Menu", MenuCoalitionRed, RemoveStatusMenu )

MESSAGE:New( "Mission script loaded successfully", 25, "INFO" ):ToAll():ToLog()
