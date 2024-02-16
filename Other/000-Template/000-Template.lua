---
-- Author: FlightControl
-- Created: 23.02.2017
-- Contributors: kaltokri
-- Modified: 16.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Message.html
--
-- # Description:
--
-- This is a template mission, which can be used to create new demo missions.
-- 
-- # Guide:
-- 
-- 1. Start the mission and see a "Hello World!..." message at the right upper corner.

MESSAGE:New( "Hello World! This messages is printed by MOOSE", 35, "INFO" ):ToAll()
