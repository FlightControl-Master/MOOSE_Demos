---
-- Author: FlightControl
-- Created: 10.12.2017
-- Contributors: kaltokri
-- Modified: 27.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
--
-- # Description:
-- This mission will show the option to set the alarm state of a group to RED or GREEN.
-- Both options are tested with one group for each.
-- Please check the dcs.log in case of errors, and the time the group reacts to the approaching target.
-- The Red State Group should react much faster than the Green State Group.
-- State Blue is attacking. State Green is defending.
-- The south SAM is "Red State".
--
-- # Guide:
-- 1. Start the mission.
-- 2. Watch the situation on F10 map.

-- Find the SAMs and create GROUP objects.
RedStateGroup = GROUP:FindByName( "Red State" )
GreenStateGroup = GROUP:FindByName( "Green State" )

-- Set the states.
RedStateGroup:OptionAlarmStateRed()
GreenStateGroup:OptionAlarmStateGreen()
