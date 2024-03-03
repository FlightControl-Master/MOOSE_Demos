---
-- Author: FlightControl
-- Created: 09.04.2017
-- Contributors: kaltokri
-- Modified: 01.03.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.SpawnStatic.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Static.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
--
-- # Description:
--
-- In this mission we spawn a static near Gudauta.
-- Around this object we create two circles with containers to mark the target area.
-- NOTE: Instead of a STATIC object you can also use other objects (like UNITS) to define the center position!
--
-- # Guide:
--
-- 1. Observe that the static is spawned.

-- Get object of ZONE placed in mission editor.
local zonePosition = ZONE:New( "Position" )

-- Create SPAWNSTATIC objects.
local spawnCommandCenter = SPAWNSTATIC:NewFromStatic( "CommandCenter", country.id.GERMANY )
local spawnBarrack  = SPAWNSTATIC:NewFromStatic( "Barrack", country.id.GERMANY )

-- Get the position of the zone.
local zonePointVec2 = zonePosition:GetPointVec2()

-- Spawn the CommandCenter in the center of the zone.
local commandCenter = spawnCommandCenter:SpawnFromZone( zonePosition, 0 )

-- Create 6 barracks around the CommandCenter.
for Heading = 0, 360, 60 do
  local radial = Heading * ( math.pi*2 ) / 360
  local x = zonePointVec2:GetLat() + math.cos( radial ) * 150
  local y = zonePointVec2:GetLon() + math.sin( radial ) * 150
  spawnBarrack:SpawnFromPointVec2( POINT_VEC2:New( x, y ), Heading + 90 )
end
