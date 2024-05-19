---
-- Author: Wingthor and Saint185
-- Created: 15.01.2021
-- Contributors: kaltokri
-- Modified: 18.05.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Menu.html
--
-- # Description:
--
-- A squad with four Su-25T is placed. One player with 3 AI.
-- After a few seconds a menu is added to check loadout of the AI.
--
-- Check the code on how to create a dynamic menu with a for-iteration and a table.
-- A forward declaration of a function is used in this example.
-- The logic of this script is universal. It will work with any human flyable plane.
-- No matter of coalition RED or BLUE. Just name your GROUP "Player".
-- Under the Skill box select "client" as your own plane.
--
-- # Guide:
-- - Start the mission, choose coalition BLUE and Pilot slot.
-- - Wait a few seconds and open radio menu F10 Others...
-- - Choose loadout to print.


BASE:TraceOnOff(true)
BASE:TraceAll(true)

------------------------------------ GLOBALS For easy mission tweaking -------------------------------------------------
CASZone = "Zone Charlie"
PlayersGroupName = "Player"
BuildMenu = function() end -- Forward declaration
------------------------------------ END GLOBALS -----------------------------------------------------------------------

env.info ("------------------------- STARING SCRIPT ---------------------------------")

--Create TASK Zone
local zoneCharlie = ZONE:New(CASZone)

-- Add scheduled command, now holds the BuildMenu Call.
local start = SCHEDULER:New(nil,
  function()
    -- Create a flight group.
    flightgroup = FLIGHTGROUP:New(PlayersGroupName)
    flightgroup:SetDetection(true)

    --- Function called when the group detects a previously unknown unit.
    function flightgroup:OnAfterDetectedUnitNew(From, Event, To, Unit)
      local unit = Unit --Wrapper.Unit#UNIT
      -- Message to everybody and in the DCS log file.
      local text = string.format("Detected unit %s", unit:GetName())
      MESSAGE:New(text, 20,flightgroup:GetName()):ToAll()
      env.info(text)
    end

    -- Create a CAS mission.
    local mission = AUFTRAG:NewCAS(zoneCharlie)
    mission:SetEngageAltitude(10000)
    mission:SetWeaponExpend(AI.Task.WeaponExpend.ONE)

    -- Assign mission to pilot.
    flightgroup:AddMission(mission)
    -- Build Menu for ammo check.
    BuildMenu()
  end,
{},1,30000 )

--- Function to check ammo for a give wingman.
-- @param Wingman number
local function AmmoCheck(Wingman)
  -- Gets the ammo for each unit and dumps it into unittable TABLE.
  local unitsAmmoTable = units[Wingman]:GetAmmo()

  -- Gets the callsign for each unit and dumps it into callsign TABLE.
  local callsign = units[Wingman]:GetCallsign()

  -- This logic splits out each ammo type and name and inserts it into the message.
  local count = {}
  local desc = {}
  -- local ammoUnits = ammo[2]
  local WepMessage = "   "
  for i = 1, #unitsAmmoTable do
    local ammocount = unitsAmmoTable[i].count
    local ammodesc = unitsAmmoTable[i].desc.displayName
    table.insert (count, ammocount)
    table.insert (desc, ammodesc)
    WepMessage = WepMessage .. desc[i] .. ": " .. count[i] .. "\n   "
  end
  MESSAGE:New( callsign ..":\n------------------------------------\n" .. WepMessage, 10):ToAll()
end

local function CheckAll()
  -- Gets the number of units in the group
  units = GROUP:FindByName( PlayersGroupName ):GetUnits()
  for i = 2, #units do
    AmmoCheck(i)
  end
end

BuildMenu = function()
  BASE:I("--- Info: Building menu ---")

  -- Gets the number of units in the group
  units = GROUP:FindByName( PlayersGroupName ):GetUnits()

  -- AmmoCheckMainMenu
  Level1 = MENU_MISSION:New( "Flight Ammo Check" )
  LevelMenues = {}
  CommandMenues = {}
  for i = 2, #units do
    LevelMenues[i] = MENU_MISSION:New( "Wingman " .. i, Level1 )
    CommandMenues[i] = MENU_MISSION_COMMAND:New("AmmoStatus " ..  i, LevelMenues[i], AmmoCheck, i)
  end
  CommandMenuesAll = MENU_MISSION_COMMAND:New("AmmoStatus All", Level1, CheckAll)
end

-- BASE:ScheduleOnce(10,BuildMenu) If you prefer a scheduled command

HandleDeath = EVENTHANDLER:New():HandleEvent(EVENTS.Dead)

function HandleDeath:OnEventDead(EventData)
  if EventData.IniGroupName == PlayersGroupName then
    BuildMenu()
  end
end
