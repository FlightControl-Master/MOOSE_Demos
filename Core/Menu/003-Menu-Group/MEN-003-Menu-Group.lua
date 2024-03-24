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
-- Very simple example of the MENU_GROUP.
-- We added two planes and give them different menu entries.
-- We need a timer to check regularly if someone entered the plane.
--
-- # Guide:
--
-- 1.  Start the mission.
-- 2.  Enter as Plane-1.
-- 3.  Wait for "loaded successfully" message and then 5 seconds more.
-- 4.  Open menu by pressing #
-- 5.  Choose F11. Parent Menu
-- 6.  Choose F10. Other...
-- 7.  Select F2. Menu for Plane-1...
-- 8.  Select F1. Accept CAS mission and see the message.
-- 9.  Switch to Plane-2 and wait 5 seconds.
-- 10. Open menu by pressing #
-- 11. Choose F11. Parent Menu
-- 12. Choose F10. Other...
-- 13. Select F2. Menu for Plane-2...
-- 12. Select F1. Accept BAI mission and see the message.


-- Example function
local function PrintTheTextToBlue( text )
  MESSAGE:New( text, 25, "INFO" ):ToBlue()
end

-- Start a scheduler after a delay of 5 seconds and repeat it's execution very 5 seconds
SCHEDULER:New( nil,
  function()
    -- Find both groups and save them in an object
    local PlaneGroup1 = GROUP:FindByName( "Plane-1" )
    local PlaneGroup2 = GROUP:FindByName( "Plane-2" )

    -- Add menu for the first group
    if PlaneGroup1 and PlaneGroup1:IsAlive() then
      local MenuGroup1 = MENU_GROUP:New( PlaneGroup1, "Menu for Plane-1" )
      MENU_GROUP_COMMAND:New( PlaneGroup1, "Accept CAS mission", MenuGroup1, PrintTheTextToBlue, "Plane-1 accepts the CAS mission" )
      MESSAGE:New( "Menu added to Group1.", 1, "INFO" ):ToLog()
    else
      MESSAGE:New( "Group1 is not available.", 1, "INFO" ):ToLog()
    end

    -- Add menu for the second group
    if PlaneGroup2 and PlaneGroup2:IsAlive() then
      local MenuGroup2 = MENU_GROUP:New( PlaneGroup2, "Menu for Plane-2" )
      MENU_GROUP_COMMAND:New( PlaneGroup2, "Accept BAI mission", MenuGroup2, PrintTheTextToBlue, "Plane-2 accepts the BAI mission" )
      MESSAGE:New( "Menu added to Group2.", 1, "INFO" ):ToLog()
    else
      MESSAGE:New( "Group2 is not available.", 1, "INFO" ):ToLog()
    end
  end, {}, 5, 5 )

MESSAGE:New( "Mission script loaded successfully", 25, "INFO" ):ToAll():ToLog()
MESSAGE:New( "The script will check every 5 seconds if group is available and add the menu.", 25, "INFO" ):ToAll():ToLog()
