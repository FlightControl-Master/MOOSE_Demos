---
-- Author: Saint185
-- Created: 21.11.2020
-- Contributors: kaltokri
-- Modified: 18.05.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Menu.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Static.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Point.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Utilities.Utils.html
--
-- # Description:
--
-- This demo creates a menu structure to send messages with coordinates of targets to all players.
-- The code can be optimized a lot. But it is an working example create by a moose user.
--
-- # Guide:
-- - Enter the slot TACTICAL CMDR.
-- - Open radio menu F10 Other...
-- - F1 TARGETCOORDS...
-- - Choose target category and target.
-- - See Message with the coordinates on the screen.


_SETTINGS:SetPlayerMenuOff()

-- Find the static EastAmmoDump defined in the Mission Editor.
-- Get it's coordinate and save it for later use.
-- Determine it's height and save it for later use.
local AmmoDumpEast = STATIC:FindByName( "AmmoDumpEast" )
local AmmoDumpEastCOORD = AmmoDumpEast:GetCoordinate() --contains the LLDMS coordinates for JDAM
local AmmoDumpEastHeight = AmmoDumpEastCOORD:GetLandHeight() --gets the land height Bridge 32 from T1COORD

-- Do the same for AmmoDumpWest.
local AmmoDumpWest = STATIC:FindByName( "AmmoDumpWest" )
local AmmoDumpWestCOORD = AmmoDumpWest:GetCoordinate()
local AmmoDumpWestHeight = AmmoDumpWestCOORD:GetLandHeight()

-- Do the same for AmmoDumpSouth.
local AmmoDumpSouth = STATIC:FindByName( "AmmoDumpSouth" )
local AmmoDumpSouthCOORD = AmmoDumpSouth:GetCoordinate()
local AmmoDumpSouthHeight = AmmoDumpSouthCOORD:GetLandHeight()

-- Do the same for AmmoDumpNorth.
local AmmoDumpNorth = STATIC:FindByName( "AmmoDumpNorth" )
local AmmoDumpNorthCOORD = AmmoDumpNorth:GetCoordinate()
local AmmoDumpNorthHeight = AmmoDumpNorthCOORD:GetLandHeight()

-- Zone placed on Bridges in ME.
-- Get and safe it's data.
local Target_1 = ZONE:New( "Bridge32" )
local T1COORD = Target_1:GetCoordinate() -- Contains the LLDMS coordinates for JDAM
local T1Height = T1COORD:GetLandHeight() -- Gets the land height Bridge 32 from T1COORD

local Target_2 = ZONE:New( "Bridge33" )
local T2COORD = Target_2:GetCoordinate()
local T2Height = T2COORD:GetLandHeight()

-- Do the same for Zones placed on some shelters.
local Target_3 = ZONE:New( "HardenedHanger33" )
local T3COORD = Target_3:GetCoordinate()
local T3Height = T3COORD:GetLandHeight()

local Target_4 = ZONE:New( "HardenedHanger34" )
local T4COORD = Target_4:GetCoordinate()
local T4Height = T4COORD:GetLandHeight()

-- Gets LLDMS coord from Target 1(Bridge32p) using T1COORD:ToStringLLDMS() then assigns sections of the string to coordXy.
local function TARGET1(T1LLDMS)
  local T1LLDMS = T1COORD:ToStringLLDMS()
  local coordN1 = string.sub(T1LLDMS,9,10) -- Extracts a block of text from String T4LLDMS starting at location 9 ending at location 10
  local coordN2 = string.sub(T1LLDMS,13,20) -- Extracts a block of text from String T4LLDMS starting at location 13 ending at location 20
  local coordE1 = string.sub(T1LLDMS,26,27) -- Extracts a block of text from String T4LLDMS starting at location 26 ending at location 27
  local coordE2 = string.sub(T1LLDMS,30,37) -- Extracts a block of text from String T4LLDMS starting at location 30 ending at location 37
  local Heightft = UTILS.MetersToFeet(T1Height) -- Converts height in meters to feet
  local T1Heightft = UTILS.Round(Heightft) -- Rounds the value to a whole number
  MESSAGE:New("Bridge 32".."\n".. ("N"..coordN1.."'"..coordN2.."\n".."E"..coordE1.."'"..coordE2.."\n".."ALT "..T1Heightft.." ft"), 50):ToAll()
  return T1LLDMS -- Returns the argument for function TARGET1
end

local function TARGET2(T2LLDMS)
  local T2LLDMS = T2COORD:ToStringLLDMS()
  local coordN1 = string.sub(T2LLDMS,9,10)
  local coordN2 = string.sub(T2LLDMS,13,20)
  local coordE1 = string.sub(T2LLDMS,26,27)
  local coordE2 = string.sub(T2LLDMS,30,37)
  local Heightft = UTILS.MetersToFeet(T2Height)
  local T2Heightft = UTILS.Round(Heightft)
  MESSAGE:New("Bridge 33".."\n".. ("N"..coordN1.."'"..coordN2.."\n".."E"..coordE1.."'"..coordE2.."\n".."ALT "..T2Heightft.." ft"), 50):ToAll()
  return T2LLDMS
end

local function TARGET3(T3LLDMS)
  local T3LLDMS = T3COORD:ToStringLLDMS()
  local coordN1 = string.sub(T3LLDMS,9,10)
  local coordN2 = string.sub(T3LLDMS,13,20)
  local coordE1 = string.sub(T3LLDMS,26,27)
  local coordE2 = string.sub(T3LLDMS,30,37)
  local Heightft = UTILS.MetersToFeet(T3Height)
  local T3Heightft = UTILS.Round(Heightft)
  MESSAGE:New("HardenedHanger 33".."\n".. ("N"..coordN1.."'"..coordN2.."\n".."E"..coordE1.."'"..coordE2.."\n".."ALT "..T3Heightft.." ft"), 50):ToAll()
  return T3LLDMS
end

local function TARGET4(T4LLDMS)
  local T4LLDMS = T4COORD:ToStringLLDMS()
  local coordN1 = string.sub(T4LLDMS,9,10)
  local coordN2 = string.sub(T4LLDMS,13,20)
  local coordE1 = string.sub(T4LLDMS,26,27)
  local coordE2 = string.sub(T4LLDMS,30,37)
  local Heightft = UTILS.MetersToFeet(T4Height)
  local T4Heightft = UTILS.Round(Heightft)
  MESSAGE:New("HardenedHanger 34".."\n".. ("N"..coordN1.."'"..coordN2.."\n".."E"..coordE1.."'"..coordE2.."\n".."ALT "..T4Heightft.." ft"), 50):ToAll()
  return T4LLDMS
end

local function TARGET5(T1LLDMS)
  local T1LLDMS = AmmoDumpEastCOORD:ToStringLLDMS()
  local coordN1 = string.sub(T1LLDMS,9,10)
  local coordN2 = string.sub(T1LLDMS,13,20)
  local coordE1 = string.sub(T1LLDMS,26,27)
  local coordE2 = string.sub(T1LLDMS,30,37)
  local Heightft = UTILS.MetersToFeet(AmmoDumpEastHeight)
  local T1Heightft = UTILS.Round(Heightft)
  MESSAGE:New("EastAmmoDump".."\n".. ("N"..coordN1.."'"..coordN2.."\n".."E"..coordE1.."'"..coordE2.."\n".."ALT "..T1Heightft.." ft"), 50):ToAll()
  return T1LLDMS
end

local function TARGET6(T2LLDMS)
  local T2LLDMS = AmmoDumpWestCOORD:ToStringLLDMS()
  local coordN1 = string.sub(T2LLDMS,9,10)
  local coordN2 = string.sub(T2LLDMS,13,20)
  local coordE1 = string.sub(T2LLDMS,26,27)
  local coordE2 = string.sub(T2LLDMS,30,37)
  local Heightft = UTILS.MetersToFeet(AmmoDumpWestHeight)
  local T2Heightft = UTILS.Round(Heightft)
  MESSAGE:New("WestAmmoDump".."\n".. ("N"..coordN1.."'"..coordN2.."\n".."E"..coordE1.."'"..coordE2.."\n".."ALT "..T2Heightft.." ft"), 50):ToAll()
  return T2LLDMS
end

local function TARGET7(T3LLDMS)
  local T3LLDMS = AmmoDumpSouthCOORD:ToStringLLDMS()
  local coordN1 = string.sub(T3LLDMS,9,10)
  local coordN2 = string.sub(T3LLDMS,13,20)
  local coordE1 = string.sub(T3LLDMS,26,27)
  local coordE2 = string.sub(T3LLDMS,30,37)
  local Heightft = UTILS.MetersToFeet(AmmoDumpSouthHeight)
  local T3Heightft = UTILS.Round(Heightft)
  MESSAGE:New("SouthAmmoDump".."\n".. ("N"..coordN1.."'"..coordN2.."\n".."E"..coordE1.."'"..coordE2.."\n".."ALT "..T3Heightft.." ft"), 50):ToAll()
  return T3LLDMS
end

local function TARGET8(T4LLDMS)
  local T4LLDMS = AmmoDumpNorthCOORD:ToStringLLDMS()
  local coordN1 = string.sub(T4LLDMS,9,10) -- Extracts text from String T4LLDMS at location 9 to 10
  local coordN2 = string.sub(T4LLDMS,13,20) -- Extracts text from String T4LLDMS at location 13 to 20
  local coordE1 = string.sub(T4LLDMS,26,27) -- Extracts text from String T4LLDMS at location 26 to 27
  local coordE2 = string.sub(T4LLDMS,30,37) -- Extracts text from String T4LLDMS at location 30 to 37
  local Heightft = UTILS.MetersToFeet(AmmoDumpNorthHeight) -- Coverts height in meters to feet
  local T4Heightft = UTILS.Round(Heightft) -- Rounds the value to a whole number
  MESSAGE:New("NorthAmmoDump".."\n".. ("N"..coordN1.."'"..coordN2.."\n".."E"..coordE1.."'"..coordE2.."\n".."ALT "..T4Heightft.." ft"), 50):ToAll()
  return T4LLDMS
end

--Coordinates Menu
Level1   = MENU_MISSION:New( "TARGETCOORDS" ) -- Top level Menu all targets are assigned to this master menu
Level2_1 = MENU_MISSION:New( "BRIDGE", Level1 ) -- Level 2 Contains Target groups
Level2_2 = MENU_MISSION:New( "AMMO DUMP", Level1 )
Level2_3 = MENU_MISSION:New( "HARDENED SHELTER", Level1 )
Menu1 = MENU_MISSION_COMMAND:New("Bridge 32", Level2_1, TARGET1) -- Level 3 contains Target group coordinates
Menu2 = MENU_MISSION_COMMAND:New("Bridge 33", Level2_1, TARGET2)
Menu3 = MENU_MISSION_COMMAND:New("HardenedHanger 33", Level2_3, TARGET3) -- Text displayed HardenedHanger 33, select Menu position, function to call(local function TARGET3(T3LLDMS))
Menu4 = MENU_MISSION_COMMAND:New("HardenedHanger 34", Level2_3, TARGET4)
Menu5 = MENU_MISSION_COMMAND:New("AmmoDumpEast", Level2_2, TARGET5)
Menu6 = MENU_MISSION_COMMAND:New("AmmoDumpWest", Level2_2, TARGET6)
Menu7 = MENU_MISSION_COMMAND:New("AmmoDumpSouth", Level2_2, TARGET7)
Menu8 = MENU_MISSION_COMMAND:New("AmmoDumpNorth", Level2_2, TARGET8)
