---
-- Author:       FlightControl
-- Created:      21.05.2018
-- Contributors: kaltokri
-- Modified:     23.02.2024
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

-- Get object for APC.
GroupApc = GROUP:FindByName( "APC" )

-- Now I can find the zone instead of doing ZONE:New, because the ZONE object is already in MOOSE.
ZoneA = ZONE:FindByName( "Zone" )
ZoneA:SmokeZone( SMOKECOLOR.White, 30 )

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
