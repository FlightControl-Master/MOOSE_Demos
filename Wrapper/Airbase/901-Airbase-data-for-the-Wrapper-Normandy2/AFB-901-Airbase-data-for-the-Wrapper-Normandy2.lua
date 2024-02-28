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
-- This mission can be used to create data for the Wrapper.Airbase class.
--
-- NOTE: io & lfs must be desanitized for this mission to work!
--
-- # Guide:
--
-- 1. Start the mission.
-- 2. When you see the message "Wrapper.Airbase data written..." you can quit the mission.
-- 3. Open your "Saved Games\DCS\Missions" folder.
-- 4. The file airbase-normandy.txt should be saved there and contain all needed data.
-- 5. This date can be used to replace the specific parts of Wrapper.Airbase.lua

-- Create a SET with all airbase of this map.
local bases = SET_AIRBASE:New():FilterOnce()

local Airbases1 = {}
local Airbases2 = {}

bases:ForEachAirbase(
  function(afb)
    local ab = afb -- Wrapper.Airbase#AIRBASE
    local name = ab:GetName()
    local nice = string.gsub(name,"([%s%c%p]+","_")
    local text1 = string.format('["%s"] = "%s",',nice,name)
    local text2 = string.format('-- * AIRBASE.Normandy.%s',nice)
    --MESSAGE:New(text,10,"Airbase"):ToLog()
    Airbases1[nice] = text1
    Airbases2[nice] = text2
  end
)

table.sort(Airbases1, function (a, b)
  return string.upper(a) < string.upper(b)
end)

local list1 = "\n"
for _nice,_text in pairs(Airbases2) do
  list1 = list1.._text.."\n"
end

local list2 = "\n"
for _nice,_text in pairs(Airbases1) do
  list2 = list2.._text.."\n"
end

filename = lfs.writedir() ..[[Missions\airbase-normandy.txt]]
filehandle = io.open( filename, "w")
filehandle:write(list1)
filehandle:write(list2)
filehandle:close()

MESSAGE:New( "Wrapper.Airbase data written to " .. filename ):ToAll()
