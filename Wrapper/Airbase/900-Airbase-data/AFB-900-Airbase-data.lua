---
-- Author: Applevangelist
-- Created: 28.02.2017
-- Contributors: kaltokri
-- Modified: 28.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Airbase.html
--
-- # Description:
--
-- This script can be used to create data for the Wrapper.Airbase class.
-- Create an empty mission with the terrain you want the data for.
-- Add Moose and this script.
-- Or use one of the already created missions in this folder.
--
-- NOTE: io & lfs must be desanitized for this mission to work!
--
-- # Guide:
--
-- 1. Start the mission.
-- 2. When you see the message "Wrapper.Airbase data written..." you can quit the mission.
-- 3. Open your "Saved Games\DCS\Missions" folder.
-- 4. The file airbase-<terrain>.txt should be saved there and contain all needed data.
-- 5. This data can be used to replace the specific parts of Wrapper.Airbase.lua

-- Create a SET with all airbase of this map.
local bases = SET_AIRBASE:New():FilterOnce()

local Airbases1 = {}
local Airbases2 = {}

local terrainName = UTILS.GetDCSMap()

bases:ForEachAirbase(
  function(afb)
    local ab = afb -- Wrapper.Airbase#AIRBASE
    local name = ab:GetName()
    local nice = string.gsub( name, "([%s%c%p]+", "_" )
    local text1 = string.format( '  ["%s"] = "%s",', nice, name )
    local text2 = string.format( '-- * AIRBASE.%s.%s', terrainName, nice )
    MESSAGE:New(nice, 10):ToLog()
    Airbases1[nice] = text1
    Airbases2[nice] = text2
  end
)

local tkeys1 = {}
local tkeys2 = {}

for k in pairs(Airbases1) do table.insert(tkeys1, k) end
for k in pairs(Airbases2) do table.insert(tkeys2, k) end

table.sort(tkeys1)
table.sort(tkeys2)

local list1 = "\n"
local list2 = "\n"

for _, k in ipairs(tkeys1) do
  list1 = list1 .. Airbases1[k] .. "\n"
end

for _, k in ipairs(tkeys2) do
  list2 = list2 .. Airbases2[k] .. "\n"
end

filename = lfs.writedir() .."Missions\\airbase-" .. terrainName .. ".txt"
filehandle = io.open( filename, "w")
filehandle:write(list1)
filehandle:write(list2)
filehandle:close()

MESSAGE:New( "Wrapper.Airbase data written to " .. filename ):ToAll()
