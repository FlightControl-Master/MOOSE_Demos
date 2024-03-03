---
-- Author: FlightControl
-- Created: 08.08.2011
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
-- On the target waypoint a task is added to call the function RouteToZone again.
-- Because of this the vehicle will drive endless from one random zone to another.
-- Note: math.random is not good with small numbers so e.g. Zone 1 is selected less frequently than zone 3.
-- Note: The script does not prevent the same zone from being selected several times in succession.
--
-- # Guide:
-- 1. Observe the APC to drive between the zones.

-- Create a list of zone objects.
local ZoneList = {
  ZONE:New( "ZONE1" ),
  ZONE:New( "ZONE2" ),
  ZONE:New( "ZONE3" ),
  ZONE:New( "ZONE4" ),
  ZONE:New( "ZONE5" )
}

-- Get needed object of APC.
GroundGroup = GROUP:FindByName( "Vehicle" )

--- @param Wrapper.Group#GROUP GroundGroup
function RouteToZone( Vehicle, ZoneRoute )
  local Route = {}

  -- Get the current coordinate of the Vehicle
  local FromCoord = Vehicle:GetCoordinate()

  -- Select a random Zone and get the Coordinate of the new Zone.
  local RandomZone = ZoneList[ math.random( 1, #ZoneList ) ] -- Core.Zone#ZONE
  local ToCoord = RandomZone:GetCoordinate()
  Vehicle:MessageToAll( "Moving to zone " .. RandomZone:GetName(), 20 )

  -- Create a task object, which will call this function.
  local TaskRouteToZone = Vehicle:TaskFunction( "RouteToZone", RandomZone )

  -- Create a list of ground waypoints. Add the task object to the target waypoint.
  -- If the vehicle will reach the waypoint the function will be triggered again.
  Route[#Route+1] = FromCoord:WaypointGround( 72 )
  Route[#Route+1] = ToCoord:WaypointGround( 72, "Vee", {TaskRouteToZone} )

  Vehicle:Route( Route, 3 ) -- Follow the Route after 3 seconds.
end

RouteToZone( GroundGroup, ZoneList[1] )
