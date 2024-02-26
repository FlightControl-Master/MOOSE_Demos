---
-- Author: FlightControl
-- Created: 24.09.2017
-- Contributors: kaltokri
-- Modified: 26.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
--
-- # Description:
-- This makes vehicles drive its route in a random way.
--
-- # Guide:
-- 1. Start the mission and wait some seconds.
-- 2. Press F10 to observe the ship and the tank traveling around.
-- 3. The boat will drive to a random red marking on the F10 map.
-- 4. The APC will drive to a random one of the placed cones.

-- Find the Vehicle and create a GROUP object.
Vehicle = GROUP:FindByName( "Vehicle" )

-- Patrol to a random chosen waypoint of the route at 120 km/h in "Vee" formation.
Vehicle:PatrolRouteRandom( 120, "Vee" )

-- Find the Ship and create a GROUP object.
Ship = GROUP:FindByName( "Ship" )

-- Patrol to a random chosen waypoint of the route at 120 km/h in "Vee" formation.
Ship:PatrolRouteRandom( 120, "Vee" )
