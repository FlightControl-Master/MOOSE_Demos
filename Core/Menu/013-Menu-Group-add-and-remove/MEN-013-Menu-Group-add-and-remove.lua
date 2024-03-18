---
-- Author: FlightControl
-- Created: 20.10.2018
-- Contributors: kaltokri
-- Modified: 18.03.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Menu.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Scheduler.html
--
-- # Description:
--
-- This demo creates a menu structure for the two groups of planes.
-- Each group will receive a different menu structure.
--
-- # Guide:
--
-- To test this mission join the planes, look at the radio menus (option F10).
-- Then switch planes and check if the menu is still there.
-- And play with the Add and Remove menu options.
-- NOTE: That will only work on multiplayer after the DCS groups bug is solved.


-- We define the variable here, so we can use it in the functions, but the status is saved on mission script level.
local MenuStatus = {}

-- A simple function to show a status text.
local function ShowStatus( PlaneGroup, StatusText, TextToCoalition )
  MESSAGE:New( TextToCoalition, 15 ):ToRed()
  PlaneGroup:Message( StatusText, 15 )
end

--- This function creates a menu entry for the red coalition to show a status message.
-- @param Wrapper.Group#GROUP MenuGroup
local function AddStatusMenu( MenuGroup )
  local MenuGroupName = MenuGroup:GetName()
  -- This would create a menu for the red coalition under the MenuCoalitionRed menu object.
  MenuStatus[MenuGroupName] = MENU_GROUP:New( MenuGroup, "Status for Planes" )
  MENU_GROUP_COMMAND:New( MenuGroup, "Show Status", MenuStatus[MenuGroupName], ShowStatus, MenuGroup, "Status of planes is ok!", "Message to Red Coalition" )
end

-- This function removes the menu entry for the red coalition to show a status message.
local function RemoveStatusMenu( MenuGroup )
  local MenuGroupName = MenuGroup:GetName()
  MenuStatus[MenuGroupName]:Remove()
end

-- Start a scheduler after a delay of 5 seconds and repeat it's execution very 5 seconds
SCHEDULER:New( nil,
  function()
    -- Find both groups and save them in an object.
    local PlaneGroup1 = GROUP:FindByName( "Plane 1" )
    local PlaneGroup2 = GROUP:FindByName( "Plane 2" )

    -- Add menu for the first group
    if PlaneGroup1 and PlaneGroup1:IsAlive() then
      local MenuGroup1 = MENU_GROUP:New( PlaneGroup1, "Manage Menus" )
      MENU_GROUP_COMMAND:New( PlaneGroup1, "Add Status Menu Plane 1", MenuGroup1, AddStatusMenu, PlaneGroup1 )
      MENU_GROUP_COMMAND:New( PlaneGroup1, "Remove Status Menu Plane 1", MenuGroup1, RemoveStatusMenu, PlaneGroup1 )
    end

    -- Add menu for the second group
    if PlaneGroup2 and PlaneGroup2:IsAlive() then
      local MenuGroup2 = MENU_GROUP:New( PlaneGroup2, "Manage Menus" )
      MENU_GROUP_COMMAND:New( PlaneGroup2, "Add Status Menu Plane 2", MenuGroup2, AddStatusMenu, PlaneGroup2 )
      MENU_GROUP_COMMAND:New( PlaneGroup2, "Remove Status Menu Plane 2", MenuGroup2, RemoveStatusMenu, PlaneGroup2 )
    end
  end, {}, 5, 5 )

MESSAGE:New( "Mission script loaded successfully", 25, "INFO" ):ToAll():ToLog()
MESSAGE:New( "The script will check every 5 seconds if group is available and add the menu.", 25, "INFO" ):ToAll():ToLog()
