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
-- In this mission two vehicles drive its route selecting random points in a zone.
--
-- # Guide:
-- 1. Start the mission and wait some seconds.
-- 2. Press F10 to observe the ship and the tank traveling around in the zones.
-- 3. Use time acceleration to shorten waiting times

-- Find the Vehicles and create GROUP objects.
Vehicle = GROUP:FindByName( "Vehicle" )
Ship    = GROUP:FindByName( "Ship" )

-- Find zones and create ZONE objects and mark both zones on the F10 map.
local zoneVehicle = ZONE:New( "ZONEVEHICLE" ):DrawZone()
local zoneShip    = ZONE:New( "ZONESHIP" ):DrawZone()

-- Patrol to random points in the trigger zone at 120 km/h in Vee format.
Vehicle:PatrolZones( { zoneVehicle }, 120, "Vee" )
Ship:PatrolZones( { zoneShip }, 120, "Vee" )
