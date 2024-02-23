---
-- Author: FlightControl
-- Created: 18.02.2017
-- Contributors: kaltokri
-- Modified: 23.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
--
-- # Description:
--
-- Three firefighters are placed.
-- We define a ZONE_POLYGON for each and use the waypoints as the shape.
-- We use different methods to choose a random point:
--   - The first 15 points are blue smoked using the GetRandomVec2() API.
--   - The second 15 points are orange smoked using the GetRandomPointVec2() API.
--   - The third 15 points are red smoked using the GetRandomPointVec3() API.
--
-- Note: At each zone an vehicle is placed, so you can view the smoking in external view (F7).
--
-- # Guide:
-- 
-- 1. Start the mission. Zoom out and switch position with F7.
-- 2. Observe smoking of Blue smoke in Zone 1.
-- 3. Observe smoking of Orange smoke in Zone 2.
-- 4. Observe smoking of Red smoke in Zone 3. 

-- Get all three ZONE_POLYGON from the groups:
Zone1 = ZONE_POLYGON:New( "Zone 1", GROUP:FindByName( "GroupA" ) )
Zone2 = ZONE_POLYGON:New( "Zone 2", GROUP:FindByName( "GroupB" ) )
Zone3 = ZONE_POLYGON:New( "Zone 3", GROUP:FindByName( "GroupC" ) )

-- Add white smoke to the borders of the zones:
Zone1:SmokeZone( SMOKECOLOR.White, 4 )
Zone2:SmokeZone( SMOKECOLOR.White, 4 )
Zone3:SmokeZone( SMOKECOLOR.White, 4 )

-- Mark 15 random points with smock inside each zone.
for i = 1, 15 do
  -- Zone 1
  local Vec2 = Zone1:GetRandomVec2()
  local PointVec2 = POINT_VEC2:NewFromVec2( Vec2 )
  PointVec2:SmokeBlue()

  -- Zone 2
  local PointVec2 = Zone2:GetRandomPointVec2()
  PointVec2:SmokeOrange()

  -- Zone 3
  local PointVec3 = Zone3:GetRandomPointVec3()
  PointVec3:SmokeRed()
end
