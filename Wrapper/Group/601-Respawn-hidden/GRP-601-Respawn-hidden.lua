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
-- In this mission a vehicle will be damaged by Explode and then respawned with full health.
--
-- # Guide:
-- 1. Start the mission and wait 10 seconds.
-- 2. The Vehicle will be damaged.
-- 3. Wait additional 10 seconds and the Vehicle will be respawned with full health.
-- Note: In this mission the vehicle is set hidden, so it is not shown on the F10 map.

-- Find the Vehicle and create a GROUP object.
Vehicle = GROUP:FindByName( "Vehicle" )

-- Damage the vehicle with a delay of 10 seconds.
Vehicle:Explode( 1, 10 )
MESSAGE:New( "Vehicle will be damaged in 10 seconds and respawn in 20 seconds!", 10 ):ToAll():ToLog()

-- Respawn the vehicle 20 seconds after mission start.
TIMER:New(
  function()
    Vehicle:Respawn()
  end
):Start( 20 )
