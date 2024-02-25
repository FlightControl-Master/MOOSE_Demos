---
-- Author: FlightControl
-- Created: 08.10.2017
-- Contributors: kaltokri
-- Modified: 23.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
--
-- # Description:
--
-- This test mission demonstrates how to get all SCENERY objects within a given zone.
--
-- # Guide:
--
-- 1. Start the mission and watch the messages with the informations of the found objects.
--
-- Note: You can resice and move the zone in mission editor to inspect different locations.
-- Important: IDs of SCENERY objects often change on terrain updates!

ZoneToScan = ZONE:New( "Zone" )
ZoneToScan:DrawZone() -- Show the zone in F10 map, so it is easy to see.

-- Scan for all objects which are of category SCENERY
ZoneToScan:Scan( Object.Category.SCENERY )

-- Process the result of the scan and print a message for each object.
for SceneryTypeName, SceneryData in pairs( ZoneToScan:GetScannedScenery() ) do
  for SceneryName, SceneryObject in pairs( SceneryData ) do
    local SceneryObject = SceneryObject -- Wrapper.Scenery#SCENERY
    MESSAGE:NewType( "Scenery: " .. SceneryObject:GetTypeName() .. ", Coord LL DMS: " .. SceneryObject:GetCoordinate():ToStringLLDMS(), MESSAGE.Type.Information ):ToAll()
  end
end
