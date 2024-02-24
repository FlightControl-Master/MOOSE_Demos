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
-- In this mission one Ka-50 (HeliGroup) will attack a group of trucks.
-- As you can see below the code to accomplish this is not trivial.
-- But it is good way to understand the details of task assignment in DCS.
-- A better way is to use new new Ops.Auftrag class.
--
-- # Test cases:
--
-- 1. Start the mission and watch the APC driving trough the zone.
-- 2. A red smoke will be deployed within the zone.

-- Get objects of the groups we need:
local HeliGroup   = GROUP:FindByName( "Helicopter" )
local TargetGroup = GROUP:FindByName( "Targets" )

-- Get all units of the target group
local TargetUnits = TargetGroup:GetUnits()

-- Create an empty list of tasks for the HeliGroup.
local HeliTasks = {}

-- Loop through all units of TargetGroup.
-- #TargetUnits is the number of elements of TargetUnits.
for i = 1, #TargetUnits do
  local TargetUnit = TargetGroup:GetUnit( i )
  -- Add an attack task to the HeliTasks table for each target unit.
  HeliTasks[#HeliTasks+1] = HeliGroup:TaskAttackUnit( TargetUnit )
end

-- As the last task add a function
HeliTasks[#HeliTasks+1] = HeliGroup:TaskFunction( "_Resume", { "''" } )

-- This is a very simple function, which only prints only a message.
-- But you can do very complex things in such a method.
-- @param Wrapper.Group#GROUP HeliGroup
function _Resume( HeliGroup )
  HeliGroup:MessageToAll( "All tasks completed.", 10, "Info") -- Show an info message for 10 seconds.
end

-- Push the list with all tasks to the HeliGroup with a delay of 10 seconds.
HeliGroup:PushTask( HeliGroup:TaskCombo( HeliTasks ), 10 )
