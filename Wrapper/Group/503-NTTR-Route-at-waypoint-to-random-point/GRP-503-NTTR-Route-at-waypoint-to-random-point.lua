---
-- Author: FlightControl
-- Created: 08.08.2017
-- Contributors: kaltokri
-- Modified: 24.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Point.html
--
-- # Description:
-- In this mission a vehicle drive (endless) to random zones when a waypoint has been reached.

-- Create a list of all zones in the mission.
local ZoneList = {
  ZONE:New( "ZONE1" ),
  ZONE:New( "ZONE2" ),
  ZONE:New( "ZONE3" ),
  ZONE:New( "ZONE4" ),
  ZONE:New( "ZONE5" ),
}

-- Get object of the APC.
VehicleGroup = GROUP:FindByName( "APC" )

--- Function to ReRoute the APC to another zone.
-- @param Wrapper.Group#GROUP RoutedGroup
function ReRoute( VehicleGroup )
  local ZoneNumber = math.random( 1, #ZoneList )

  -- Write informations to the log.
  VehicleGroup:E( "Routing" )
  VehicleGroup:E( ZoneNumber )
  -- Print informations on the screen
  VehicleGroup:MessageToAll( "Routing to Zone" .. tostring( ZoneNumber ),30 )

  -- Create Waypoints.
  local FromCoord = VehicleGroup:GetCoordinate() -- Core.Point#COORDINATE
  local FromWP = FromCoord:WaypointGround()

  local ZoneTo = ZoneList[ ZoneNumber ] -- Core.Zone#ZONE
  local ToCoord = ZoneTo:GetCoordinate()
  local ToWP = ToCoord:WaypointGround( 72, "Vee" ) -- Speed 72 km/h, formation Vee.

  -- Create a Task, which will be executed if the waypoint is reached.
  -- It will call this function again and because of that the APC will drive endless from one random point to antoher.
  local TaskReRoute = VehicleGroup:TaskFunction( "ReRoute" )
  VehicleGroup:SetTaskWaypoint( ToWP, TaskReRoute )

  VehicleGroup:Route( { FromWP, ToWP }, 1 )
end

ReRoute( VehicleGroup )
