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
-- We will give him waypoints by the script and task him to move.
--
-- # Guide:
-- 1. Observe the APC to drive 1km to the east.

-- Get needed object of APC.
local GroundGroup = GROUP:FindByName( "Vehicle" )

-- Get the current coordinate of GroundGroup.
FromCoord = GroundGroup:GetCoordinate()

-- From the current coordinate, calculate 1km away with an angle of 180 degrees (south).
ToCoord = FromCoord:Translate( 1000, 90 )

-- Create a combo task, that creates a route task to the RoutePoint.
GroundGroup:TaskRouteToVec2( ToCoord:GetVec2(), 60 ) -- Parameters: Vec2 & Speed
