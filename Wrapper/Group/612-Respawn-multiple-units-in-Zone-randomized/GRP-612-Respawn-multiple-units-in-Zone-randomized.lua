---
-- Author: FlightControl
-- Created: 01.03.2018
-- Contributors: kaltokri
-- Modified: 27.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Timer.html
--
-- # Description:
-- In this mission a vehicle group will be respawned in a zone.
-- The vehicle group consists of multiple units and are spawned randomized within the new zone.
-- The first unit will be placed at the center of the zone.
-- NOTE: InitRandomizePositionZone will not ensure, that every unit is placed within the zone!
--
-- # Guide:
-- 1. Start the mission.
-- 2. Take a look at F10 map. The vehicle group is outside of the zone.
-- 3. Wait 10 seconds.
-- 2. The vehicle group will be respawned. This time it is in the target zone.

-- Find the Vehicle and create a GROUP object.
Vehicle = GROUP:FindByName( "Vehicle" )

-- Setup RespawnZone1 linking to the trigger zone ZONEVEHICLE1.
RespawnZone1 = ZONE:New( "ZONEVEHICLE1" ):DrawZone()

-- Prepare the spawning to be done in RespawnZone1.
Vehicle:InitZone( RespawnZone1 )
Vehicle:InitRandomizePositionZone( true )

MESSAGE:New( "Vehicle will be respawned in 10 seconds in the zone!", 10 ):ToAll():ToLog()

-- Respawn the vehicle 10 seconds after mission start.
TIMER:New(
  function()
    Vehicle:Respawn( nil, true ) -- Parameters: #table Template, #boolean Reset position
  end
):Start( 10 )
