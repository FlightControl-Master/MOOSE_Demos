---
-- Author: FlightControl
-- Created: 25.03.2017
-- Contributors: kaltokri
-- Modified: 24.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Scheduler.html
--
-- # Description:
--
-- A ground unit is moving.
-- Using the command CommandStopRoute it will be stopped and starts moving again.
--
-- # Guide:
--
-- 1. Start the mission
-- 2. Observe the group is moving
-- 3. After 10 seconds it will stop.
-- 4. After additional 10 seconds it will move again.
-- 5. This will be repeated endless.

-- Function to stop movement.
--- @param Wrapper.Group#GROUP MyGroup
function StopMove( MyGroup )
  MyGroup:MessageToAll("StopMove")
  local Command = MyGroup:CommandStopRoute( true )
  MyGroup:SetCommand(Command)
end

-- Function to start movement.
--- @param Wrapper.Group#GROUP MyGroup
function StartMove( MyGroup )
  MyGroup:MessageToAll("StartMove")
  local Command = MyGroup:CommandStopRoute( false )
  MyGroup:SetCommand(Command)
end

-- Get an object of the group:
GroundGroup = GROUP:FindByName( "Ground" )

-- Run two schedulers every 20 seconds, but with different start delays:
Scheduler = SCHEDULER:New( nil )
ScheduleIDStop  = Scheduler:Schedule(nil, StopMove,  { GroundGroup }, 10, 20 ) -- 10 seconds delay from mission start
ScheduleIDStart = Scheduler:Schedule(nil, StartMove, { GroundGroup }, 20, 20 ) -- 20 seconds delay from mission start
