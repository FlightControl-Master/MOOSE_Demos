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
-- A group of trucks will move straigth into one direction.
-- We define a ZONE_GROUP which is a round zone around a group. It will move with the group leader.
-- To make the zone visible in the mission we use FlareZone.
--
-- An APC is driving zigzags through the terrain. If it is within the moving zone red smoke will be deployed.
--
-- # Guide:
--
-- 1. Start the mission and watch the moving truck convoy.
-- 2. See the recurring deployed flare to get an idea of the actual zone bounderies.
-- 3. Watch the APC driving trough the zone, a red smoke will be deployed.

-- Get object for APC.
GroupApc = GROUP:FindByName( "APC" )

-- Get object of moving truck convoi.
GroupTrucks = GROUP:FindByName( "Trucks" )

-- Get a zone attached to the group.
ZoneA = ZONE_GROUP:New( "ZoneA", GroupTrucks, 100 )

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

-- Start a scheduler to deploy a flare every 5 seconds to give you an idea of the actual zone bounderies.
TrucksZoneColoring = SCHEDULER:New( nil,
  function()
    ZoneA:FlareZone( FLARECOLOR.White, 90, 60 )
  end, 
  {}, 0, 5
)
