---
-- Author: FlightControl
-- Created: 20.10.2018
-- Contributors: kaltokri
-- Modified: 24.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
--
-- # Description:
--
-- In this mission one Ka-50 (HeliGroup) will start from a FARP.
-- Normally it would fly a big polygon shaped patrol around the FARP.
-- At the end it will land back on the FARP.
-- But in the code below we change the route dynamically.
-- So instead of flying to waypoint 2, it will fly to the last waypoint 7.
--
-- # Guide:
--
-- 1. Start the mission and watch the Ka-50 flying around.

-- Get a group object of the Ka-50:
HeliGroup = GROUP:FindByName( "Helicopter" )

-- Route it back to the FARP after 60 seconds.
-- We use the SCHEDULER class to do this.
SCHEDULER:New( nil,
  function( HeliGroup )
    local CommandRTB = HeliGroup:CommandSwitchWayPoint( 2, 7 )
    HeliGroup:SetCommand( CommandRTB )
    HeliGroup:MessageToAll("We lose fuel: RTB.", 20)
  end, { HeliGroup }, 60
)
