---
-- Author: FlightControl
-- Created: 21.02.2017
-- Contributors: kaltokri
-- Modified: 23.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
--
-- # Description:
-- 
-- A ZONE_RADIUS has been defined. It's boundaries are marked with white smoke.
-- Center of the zone is placed on the postion of a bunker.
-- A vehicle is driving through the zone perimeters.
-- When the vehicle is driving inside of the zone, a red smoke is placed on the vehicle location.
-- 
-- # Test cases:
-- 
-- 1. Watch the APC driving trough the zone, a red smoke will be deployed.

-- Get object for APC.
GroupApc = GROUP:FindByName( "APC" )

-- Get object of the bunker.
Bunker = STATIC:FindByName( "Bunker" )

-- Get a zone around the bunker object and mark it with smoke.
ZoneA = ZONE_RADIUS:New( "Zone A", Bunker:GetVec2(), 300 )
ZoneA:SmokeZone( SMOKECOLOR.White, 90 )

-- Start a scheduler to test every second if the APC is inside of the zone.
-- Post a message with the result and deploy smoke if APC is within the zone.
Messager = SCHEDULER:New( nil,
  function()
    GroupApc:MessageToAll( ( GroupApc:IsCompletelyInZone( ZoneA ) ) and "Inside Zone A" or "Outside Zone A", 1 )
    if GroupApc:IsCompletelyInZone( ZoneA ) then
      GroupApc:GetUnit(1):SmokeRed()
    end
  end, 
  {}, 0, 1
)
