---
-- Author: FlightControl
-- Created: 18.02.2017
-- Contributors: kaltokri
-- Modified: 23.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
--
-- # Description:
-- 
-- A ZONE_POLYGON has been defined, which boundaries are smoking.
-- The polygon is defined by the waypoint of a BTR-80, whith activated 'LATE ACTIVATION'
-- A vehicle is driving through the zone perimeters.
-- When the vehicle is driving in the zone, a red smoke is fired from the vehicle location.
-- 
-- # Test cases:
-- 
-- 1. Start the mission and watch the APC driving trough the zone.
-- 2. A red smoke will be deployed within the zone.

-- Get object for APC.
GroupApc = GROUP:FindByName( "APC" )

-- Get object of the unit with waypoints.
GroupPolygon = GROUP:FindByName( "Polygon" )

-- Get a polygon zone and smoke the borders.
PolygonZone = ZONE_POLYGON:New( "Polygon A", GroupPolygon )
PolygonZone:SmokeZone( SMOKECOLOR.White, 20 )

-- Start a scheduler to test every second if the APC is inside of the zone.
-- Post a message with the result and deploy smoke if APC is within the zone.
Messager = SCHEDULER:New( nil,
  function()
    GroupApc:MessageToAll( ( GroupApc:IsCompletelyInZone( PolygonZone ) ) and "Inside Polygon A" or "Outside Polygon A", 1 )
    if GroupApc:IsCompletelyInZone( PolygonZone ) then
      GroupApc:GetUnit(1):SmokeRed()
    end
  end, 
  {}, 0, 1
)
