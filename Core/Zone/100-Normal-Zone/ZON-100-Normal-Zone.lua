---
-- Author:       FlightControl
-- Created:      21.02.2017
-- Contributors: kaltokri
-- Modified:     18.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
--
-- # Description:
--
-- A ZONE has been defined in mission editor. It's boundaries are marked with white smoke.
-- A vehicle is driving through the zone perimeters.
-- When the vehicle is driving within the zone, a red smoke is placed at the vehicle location.
--
-- # Guide:
--
-- 1. Start the mission.
-- 2. Observe the zone perimeter. It should be marked with white smoke.
-- 3. Observe the vehicle. It should place red smoke when driving through the zone.

GroupInside = GROUP:FindByName( "Test Inside Zone" )

ZoneA = ZONE:New( "Zone A" )
ZoneA:SmokeZone( SMOKECOLOR.White, 90 )

Messager = SCHEDULER:New( nil,
  function()
    GroupInside:MessageToAll( ( GroupInside:IsCompletelyInZone( ZoneA ) ) and "Inside Zone A" or "Outside Zone A", 1 )
    if GroupInside:IsCompletelyInZone( ZoneA ) then
      GroupInside:GetUnit(1):SmokeRed()
    end
  end,
  {}, 0, 1 )
