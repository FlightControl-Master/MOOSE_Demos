---
-- Author: FlightControl
-- Created: 24.09.2017
-- Contributors: kaltokri
-- Modified: 27.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
--
-- # Description:
-- In this mission two vehicles drive their routes selecting random points in random zones.
--
-- # Guide:
-- 1. Start the mission and wait some seconds.
-- 2. Press F10 to observe the ship and the tank traveling around in the zones.
-- 3. Use time acceleration to shorten waiting times

-- Find the Vehicles and create GROUP objects.
Vehicle = GROUP:FindByName( "Vehicle" )
Ship    = GROUP:FindByName( "Ship" )

-- Patrol to random points in the zones ZONEVEHICLE1, ZONEVEHICLE2, ZONEVEHICLE3, at 120 km/h in Vee format.
Vehicle:PatrolZones(
  {
    ZONE:New( "ZONEVEHICLE1" ):DrawZone(),
    ZONE:New( "ZONEVEHICLE2" ):DrawZone(),
    ZONE:New( "ZONEVEHICLE3" ):DrawZone()
  }, 120, "Vee" )

-- Patrol to random points in the zones ZONESHIP1, ZONESHIP2, ZONESHIP3, at 120 km/h in Vee format.
Ship:PatrolZones(
  {
    ZONE:New( "ZONESHIP1" ):DrawZone(),
    ZONE:New( "ZONESHIP2" ):DrawZone(),
    ZONE:New( "ZONESHIP3" ):DrawZone()
  }, 120, "Vee" )
