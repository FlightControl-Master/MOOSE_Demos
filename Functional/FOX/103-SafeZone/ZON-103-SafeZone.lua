---
-- Author: kaltokri
-- Created: 28.02.2024
-- Contributors: -
-- Modified: 28.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Functional.Fox.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
--
-- # Description:
-- In this mission we run a Functional FOX Missile trainer and add a safe zone.
-- Players are only protected if they are inside the zone.
-- Change client to another aircraft in mission editor as required.
-- Note: This works not for AI!
--
-- # Guide:
-- 1. Start the mission and join the Su-25T as player.
-- 2. Activate auto pilot with key A.
-- 3. Switch between external view (F2) and map (F10).
-- 4. When the aircraft is passing the first SA-13 it will fire a rocket.
-- 5. The rocket will explode prior reaching your aircraft, because your aircraft is still in the SafeZone.
-- 6. Fly straight ahead and after leaving the SafeZone missiles (no matter from which SA-13) will damage you.

-- Create a new missile trainer object.
fox=FOX:New()

-- Get zone object and draw the zone in F10 map.
SafeZone = ZONE:New( "FOX_Safe_Zone" )
               :DrawZone( -1, {1,0,0}, 1, {1,0,0}, 0.3, true )

-- Add training Safe zones.
fox:AddSafeZone( SafeZone )

-- Start missile trainer.
fox:Start()
MESSAGE:New( "FOX missile trainer started", 25, "INFO" ):ToAll():ToLog()
