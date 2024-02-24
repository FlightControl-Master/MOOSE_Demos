---
-- Author: FlightControl
-- Created: 20.10.2018
-- Contributors: kaltokri
-- Modified: 24.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Point.html
--
-- # Description:
--
-- In this two planes will be spawned.
-- The second one will follow the first one.
--
-- # Guide:
--
-- 1. Start the mission and watch the planes moving.

-- Create spawn objects from groups:
local SpawnPlane1 = SPAWN:New("Plane 1")
local SpawnPlane2 = SPAWN:New("Plane 2")

-- Spawn the groups into the world:
local GroupPlane1 = SpawnPlane1:Spawn()
local GroupPlane2 = SpawnPlane2:Spawn()

--Create a task for Plane 2 (follow GroupPlane1 at Vec3 offset):
local PointVec3 = POINT_VEC3:New( 100, 0, -100 ) -- This is a Vec3 class.
local FollowDCSTask = GroupPlane2:TaskFollow( GroupPlane1, PointVec3:GetVec3() )

-- Activate Task with SetTask.
-- PushTask will push a task on the execution queue of the group.
-- SetTask will delete all tasks from the current group queue and executes this task.
-- We use SetTask this time:
GroupPlane2:SetTask( FollowDCSTask, 1 )
