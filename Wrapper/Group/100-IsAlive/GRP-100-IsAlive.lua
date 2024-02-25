---
-- Author: FlightControl
-- Created: 21.02.2017
-- Contributors: kaltokri
-- Modified: 23.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
--
-- # Description:
--
-- In this demo mission we will show how to use the method IsAlive() on group level.
-- Two ground forces GROUPS are shooting each other (T-80 vs M2A2).
--
-- # Guide:
--
-- 1. Run the mission and check the messages.
-- 2. If a unit is dead the returned value will be nil

-- Create Spawn Groups:
local GroupBlue = GROUP:FindByName( "Blue" )
local GroupRed = GROUP:FindByName( "Red" )
local GroupObserver = GROUP:FindByName( "Observer" )

-- Start a scheduler to test every second if the groups are alive and post a status message.
local Schedule, ScheduleID = SCHEDULER:New( nil,
  function( GroupBlue, GroupRed )
    local IsAliveBlue = GroupBlue:IsAlive()
    local IsAliveRed = GroupRed:IsAlive()

    GroupObserver:MessageToAll( "IsAliveBlue=" .. tostring(IsAliveBlue) .. " ----- IsAliveRed=" .. tostring(IsAliveRed), 1 )
  end, { GroupBlue, GroupRed }, 1, 1
)
