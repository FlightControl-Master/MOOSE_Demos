---
-- Author: FlightControl
-- Created: 20.10.2018
-- Contributors: kaltokri
-- Modified: 25.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Point.html
--
-- # Description:
--
-- An APC is placed in the mission editor without any waypoints.
-- We will give him a waypoint by the script and task him to move.
--
-- # Guide:
-- 1. Observe the APC to drive 1km to the east.

-- Get needed object of APC.
local GroundGroup = GROUP:FindByName( "Vehicle" )

-- Get the current coordinate of APC.
FromCoord = GroundGroup:GetCoordinate()

-- From the current coordinate, calculate 1km away with an angle of 90 degrees (south).
ToCoord = FromCoord:Translate( 1000, 90 )

-- Create an empty list of route points.
RoutePoints = {}

-- Create a list of "ground route points", which is a "point" structure that can be given as a parameter to a Task.
RoutePoints[#RoutePoints+1] = FromCoord:WaypointGround( 0 ) -- Parameters: Speed
RoutePoints[#RoutePoints+1] = ToCoord:WaypointGround( 60, "Cone" ) -- Parameters: Speed, Formation

-- Create a combo task, that creates a route task to the RoutePoint
RouteTask = GroundGroup:TaskRoute( RoutePoints )

-- Set the task to be executed by the GroundGroup
GroundGroup:SetTask( RouteTask, 1 )
