---
-- Author: Wingthor
-- Created: 22.08.2020
-- Contributors: kaltokri
-- Modified: 23.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Point.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Scheduler.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Spawn.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Static.html
--
-- # Description:
-- Mission illustrates how to make an air GROUP do a bomb run by script.
-- One template group is placed on map by DCS's Mission Editor.
-- Template is set to TASK "Ground Attack" and given proper ordonance in Mission Editor.
-- One function handles both attacks by give targets coordinates as arguments.
-- This also shows how to do a delayed function call using BASE:ScheduleOnce function.
-- Mission also feature a helper function which will return a random waypoint between Airbase and Target.
--
-- # Guide:
-- 1. Start the mission and wait 5 seconds
-- 2. Press F2/F10 to observe the attack run of the blue aircrafts
-- 3. Use time acceleration to shorten waiting times

-- Enable tracing when the mission doesn't work as expected.
--BASE:TraceOnOff(true)
--BASE:TraceAll(true)

--- This function will make a random waypoint between two coordinates.
-- @param Core.Point#COORDINATE TargetCoordinate Coordinate of the target
-- @param Core.Point#COORDINATE InitCoordinate Initial Coordinate
function MakeMiddleWaypoint (TargetCoordinate, InitCoordinate)
  BASE:F({TargetCoordinate,InitCoordinate})

  -- If we can not resolve the parameters throw noting back so we don't break anything.
  if TargetCoordinate == nil or InitCoordinate == nil then return nil end

  local _TargetCoordinate = TargetCoordinate -- Core.Point#COORDINATE
  local _InitCoordinate = InitCoordinate -- Core.Point#COORDINATE
  local Distance = TargetCoordinate:Get3DDistance( InitCoordinate )

  if Distance < 30000 then
    return nil -- To close for us
  elseif Distance > 70000 then
    Distance = 70000
  else
    Distance = math.random(30000,70000)
  end -- This is max distance from target we want our Waypoint

  local Direction  = _TargetCoordinate:GetAngleDegrees(_TargetCoordinate:GetDirectionVec3(_InitCoordinate))

  if Direction > 0 and Direction <=90 then -- North East
    return _TargetCoordinate:Translate( Distance, math.random(1,90) )
  elseif Direction > 90 and Direction <= 180 then -- South East
    return _TargetCoordinate:Translate( Distance, math.random(91,180) )
  elseif Direction > 180 and Direction <= 270 then -- South West then
    return _TargetCoordinate:Translate( Distance,math.random(181,270) )
  elseif Direction > 270 and Direction <= 360 then -- South West then then
    return _TargetCoordinate:Translate( Distance,math.random(271,360) )
  else
    BASE:E("--- Something wrong in function MakeMiddleWaypoint ---")
    return nil
  end
end


--- Function to order a strike
-- @param #string Group Name of the group
-- @param Core.Point#COORDINATE Target Coordinates of the target
-- @param #string Base Name of the home base
-- @param #string TargetDescription Description of the target
function PinpointStrike( Group, Target, Base, TargetDescription )
  BASE:F({ Group, Target, Base })

  -- nil check for arguments.
  if Group == nil or Target == nil or Base == nil then return nil end

  -- Make a default description
  if TargetDescription == nil then
    TargetDescription = "Bomb Target"
  end

  -- Make a Random heading from the target which will serve as an IP (90-180°)
  local heading = math.random( 90, 180 )

  -- Get targets vectors
  local targetVec = Target:GetVec2()

  -- Make a Spawn counter
  if SpawnCounter == nil then
    SpawnCounter = 0
  else
    SpawnCounter = SpawnCounter + 1
  end

  -- Spawn the bomber and return a GROUP object
  local SpawnBomber = SPAWN:NewWithAlias( Group, "Bomber_" .. tostring(SpawnCounter) )
    :OnSpawnGroup(
      --- @param
      function ( group  )
        group:MessageToBlue( "Launching the Pinpoint strike", 40 )
      end, {}
    )

  local homebasecoords = AIRBASE:FindByName(Base):GetCoordinate() --Core.Point#COORDINATE
  local bomber = SpawnBomber:SpawnAtAirbase( AIRBASE:FindByName( Base ), SPAWN.Takeoff.Cold )
  local task = bomber:TaskBombing( targetVec, false, "All", nil, heading, 10000)

  --- Make a waypoint table
  local waypoints = {}

  --- Get coordinate for Home Base
  local homecoords = AIRBASE:FindByName(Base):GetCoordinate():SetAltitude(8000):Translate(10 * 10000,300)

  -- Make an ingress point for the bomber
  local IngressPoint = MakeMiddleWaypoint( Target, homebasecoords ) --Core.Point#COORDINATE
  if IngressPoint == nil then -- Its important to handle the edge cases so we don't break anything. Better throw something to log.
    BASE:E("--- Error in PinpointStrike target is too close to base ---" )
    return nil
  end

  -- Set the coordinate altitude
  IngressPoint:SetAltitude(8000)

  -- Add coordinates to table and make Waypoints
  waypoints[1] = homebasecoords:WaypointAirTakeOffParking()
  waypoints[2] = IngressPoint:WaypointAirTurningPoint( nil, 950, {task}, TargetDescription )
  waypoints[3] = homecoords:WaypointAirTurningPoint()
  waypoints[4] = homebasecoords:WaypointAirLanding()

  -- Push the waypoint table the bomber
  bomber:Route( waypoints )

end

-- local targetCoords = ZONE:New("Blue Bridge"):GetCoordinate()
local CommandCenterCoords = STATIC:FindByName( "SAM ControlCenter", false ):GetCoordinate() -- Core.Point#COORDINATE

-- I have added a small zone over a scenery object in order to grab the coordinates.
local SceneryTargetCoordiate = ZONE:New("SceneryTarget"):GetCoordinate()

-- Call the function PinpointStrike 5 seconds after mission start with 4 parameters: Group, Target, Base, TargetDescription
BASE:ScheduleOnce(  5, PinpointStrike, "Blue Owl 1-1", CommandCenterCoords, AIRBASE.Caucasus.Sukhumi_Babushara, "Bomb Command Center" )

-- Call the function PinpointStrike 10 seconds after mission start with 4 parameters: Group, Target, Base, TargetDescription
BASE:ScheduleOnce( 10, PinpointStrike, "Blue Owl 1-1", SceneryTargetCoordiate, AIRBASE.Caucasus.Sukhumi_Babushara, "Bomb Commanders House" )
