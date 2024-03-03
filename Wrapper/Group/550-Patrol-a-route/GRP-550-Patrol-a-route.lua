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
-- In this mission two vehicles drive their route in a repetitive way.
--
-- # Guide:
-- 1. Start the mission and wait some seconds.
-- 2. Press F10 to observe the ship and the tank traveling around.
-- 3. The boat will drive to the red markings on the F10 map.
-- 4. The APC will drive to the placed cones.
-- 5. Use time acceleration to shorten waiting times

-- Find the Vehicle and create a GROUP object.
Vehicle = GROUP:FindByName( "Vehicle" )

-- Patrol the route of the Vehicle.
Vehicle:PatrolRoute()

-- Find the Ship and create a GROUP object.
Ship = GROUP:FindByName( "Ship" )

-- Patrol the route of the Ship.
Ship:PatrolRoute()
