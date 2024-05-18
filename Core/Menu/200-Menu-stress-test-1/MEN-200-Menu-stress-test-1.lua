---
-- Author: FlightControl
-- Created: 07.04.2021
-- Contributors: kaltokri
-- Modified: 18.05.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Menu.html
--
-- # Description:
--
-- This demo creates a menu structure to dynamically add menus for different groups of planes and coalition.
-- It shows how to create a flexible menu structure and how to remove or add entries to it.
--
-- # Guide:
--
-- To test this mission join the planes, look at the radio menus (option F10).
-- Call all "Generate ... Menus" multiple times.
-- Switch planes and coalition to check the menu.
-- And test also the Remove menu options.


-- Create a table to save each menu entry in it.
-- This will allow us to remove them easily later on.
TestMenus = {}

-- A table to transform the coalition.side from object to text.
local CoalitionText = {
  [coalition.side.BLUE] = "BLUE",
  [coalition.side.RED] = "RED",
}

-- Simple function to show a message.
-- This is a placeholder to start the real mission.
local function MenuMessage( Text, Parameter )
  MESSAGE:NewType( Text .. Parameter, MESSAGE.Type.Information ):ToAll()
end

-- Function to remove a menu entry.
local function MenuRemove(m)
  TestMenus[m]:Remove()
end

-- Function to generate a mission menu, visible for both sides
local function GenerateMissionMenu()

  -- Get number of table entries and increase it to append new ones.
  local m = #TestMenus+1

  -- Add top menu entry
  TestMenus[m] = MENU_MISSION:New( "Menu Mission "..m  )

  -- Generate sub menu entries for 8 sub mission.
  for n = 1, 8 do
    local MenuMissionCommand = MENU_MISSION_COMMAND:New( "Show Mission "..m.."."..n, TestMenus[m], MenuMessage, "Mission ", m.."."..n)
  end

  -- Add an entry to remove the this sub menu entries.
  local MenuMissionRemoveCommand = MENU_MISSION_COMMAND:New( "Remove Mission "..m, TestMenus[m], MenuRemove, m)
end

-- Function to generate a Coalition menu, visible for one sides, given as paramenter
local function GenerateCoalitionMenu( Coalition )

  -- Get number of table entries and increase it to append new ones.
  local m = #TestMenus+1

  -- Add top menu entry
  TestMenus[m] = MENU_COALITION:New( Coalition, "Menu Coalition "..CoalitionText[Coalition].." ".. m  )

  -- Generate sub menu entries for 8 sub mission.
  for n = 1, 8 do
    local MenuMissionCommand = MENU_COALITION_COMMAND:New( Coalition, "Show Coalition "..CoalitionText[Coalition].." "..m.."."..n, TestMenus[m], MenuMessage, "Coalition ", CoalitionText[Coalition].." "..m.."."..n)
  end

  -- Add an entry to remove the this sub menu entries.
  local MenuMissionRemoveCommand = MENU_COALITION_COMMAND:New( Coalition, "Remove Coalition "..CoalitionText[Coalition].." "..m, TestMenus[m], MenuRemove, m)
end

-- Create a MENU_MISSION root entry
Menu = MENU_MISSION:New( "Generate Menus" )

-- First entry will generate a top level menu entry of type mission menu, which is visible for all.
-- Second and third will generate coalition specific entries.
local MenuMission       = MENU_MISSION_COMMAND:New( "Generate Mission Menus",         Menu, GenerateMissionMenu )
local MenuCoalitionBlue = MENU_MISSION_COMMAND:New( "Generate Blue Coalition Menus",  Menu, GenerateCoalitionMenu, coalition.side.BLUE )
local MenucoalitionRed  = MENU_MISSION_COMMAND:New( "Generate Red Coalition Menus",   Menu, GenerateCoalitionMenu, coalition.side.RED )
