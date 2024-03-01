---
-- Author: buur
-- Created: 29.02.2024
-- Contributors: kaltokri
-- Modified: 01.03.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.SpawnStatic.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Static.html
--
-- # Description:
--
-- In this mission we search for a placed container with the UNIT name CircleCenterContainer.
-- Around this object we create two circles with containers to mark the target area.
-- NOTE: Instead of a STATIC object you can also use other objects (like UNITS) to define the center position!
--
-- # Guide:
--
-- 1. Start the mission and take a look at the placed containers.

--- Creates a circle with static objects around a given coordinate.
-- @param Core.Point#COORDINATE circleCenter The coordinate for the center of the circle.
-- @param #number radius (Optional) The radius of the circle. Default 150.
-- @param #number step (Optional) The distance in degrees between the objects. Default 15.
-- @param #string prefix (Optional) The prefix for the name of the STATIC objects. Default is innerCircle.
-- @param #string category (Optional) The category of the STATIC object to use. Default is Fortifications.
-- @param #string staticType (Optional) The type of the STATIC object to use. Default is container_40ft.
-- @param #string staticShape (Optional) The shape of the STATIC object to use. Default is container_40ft.
-- @param #string staticLivery (Optional) The livery name of the STATIC object to use. Default is summer.
function targetcircle( circleCenter, radius, step, prefix, category, staticType, staticShape, staticLivery )
  local circleCenter  = circleCenter
  local radius        = radius  or 150
  local step          = step    or 15
  local prefix        = prefix        or "innerCircle" -- Must be unique!
  local category      = category      or "Fortifications"
  local staticType    = statictype    or "container_40ft"
  local staticShape   = staticshape   or "container_40ft"
  local staticLivery  = staticlivery  or "summer"

  for angle = 0, 360-step , step do
    local name = string.format( "%s#%f", prefix, angle )
    local circle = circleCenter:Translate( radius, angle, false, false )
    SPAWNSTATIC
      :NewFromType( staticType, category )
      :InitCoordinate( circle )
      :InitLivery( staticLivery )
      :InitHeading( angle )
      :InitShape( staticShape )
      :Spawn( nil, name )
  end
end

local circleCenter = STATIC:FindByName( "CircleCenterContainer", true ):GetCoordinate()
targetcircle( circleCenter )
targetcircle( circleCenter, 250, nil, "outerCircle" )

MESSAGE:New( "Containers are in place now", 35, "INFO" ):ToAll():ToLog()
