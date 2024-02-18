---
-- Author:       FlightControl
-- Created:      31.03.2017
-- Contributors: kaltokri
-- Modified:     18.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Zone.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Message.html
--
-- A ZONE has been defined in mission editor. Three groups are placed in the area.
-- The zone will be marked by white smoke and very group is marked by smoke in different colors.
--
-- # Guide:
--
-- 1. Start the mission.
-- 2. Locate the zone marked with white smoke.
-- 3. Search the different groups and their units.
-- 4. Compare the situation with the messages.

function SmokeEveryUnit( Group, Color )
  local units = Group:GetUnits()
  for i, unit in ipairs(units) do
    unit:Smoke( Color, nil, 2 )
  end
end

GroupGreen  = GROUP:FindByName( "GroupGreen" )
GroupOrange = GROUP:FindByName( "GroupOrange" )
GroupBlue   = GROUP:FindByName( "GroupBlue" )

Zone = ZONE:New( "Zone" )
Zone:SmokeZone( SMOKECOLOR.White, 90 )

SmokeEveryUnit(GroupBlue,SMOKECOLOR.Blue)
GroupBlue:MessageToAll( "Group is completely in Zone: " .. tostring( GroupBlue:IsCompletelyInZone( Zone ) ), 120 )
GroupBlue:MessageToAll( "Group is partially in Zone:  " .. tostring( GroupBlue:IsPartlyInZone( Zone ) ), 120 )
GroupBlue:MessageToAll( "Group is not in Zone:        " .. tostring( GroupBlue:IsNotInZone( Zone ) ), 120 )
MESSAGE:New( "---", 120 ):ToAll()

SmokeEveryUnit(GroupGreen,SMOKECOLOR.Green)
GroupGreen:MessageToAll( "Group is completely in Zone: " .. tostring( GroupGreen:IsCompletelyInZone( Zone ) ), 120 )
GroupGreen:MessageToAll( "Group is partially in Zone:  " .. tostring( GroupGreen:IsPartlyInZone( Zone ) ), 120 )
GroupGreen:MessageToAll( "Group is not in Zone:        " .. tostring( GroupGreen:IsNotInZone( Zone ) ), 120 )
MESSAGE:New( "---", 120 ):ToAll()

SmokeEveryUnit(GroupOrange,SMOKECOLOR.Orange)
GroupOrange:MessageToAll( "Group is completely in Zone: " .. tostring( GroupOrange:IsCompletelyInZone( Zone ) ), 120 )
GroupOrange:MessageToAll( "Group is partially in Zone:  " .. tostring( GroupOrange:IsPartlyInZone( Zone ) ), 120 )
GroupOrange:MessageToAll( "Group is not in Zone:        " .. tostring( GroupOrange:IsNotInZone( Zone ) ), 120 )
