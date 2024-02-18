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
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Set.html
--
-- A ZONE has been defined in mission editor. Multiple groups are placed in the area.
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

SetGroupObject = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes("Group"):FilterStart()

Zone = ZONE:New( "Zone" )
Zone:SmokeZone( SMOKECOLOR.White, 90 )

SetGroupObject:ForEachGroupCompletelyInZone( Zone,
  function( GroupObject )
    GroupObject:MessageToAll( "I am completely in Zone", 120 )
    SmokeEveryUnit(GroupObject,SMOKECOLOR.Blue)
  end )

SetGroupObject:ForEachGroupPartlyInZone( Zone,
  function( GroupObject )
    GroupObject:MessageToAll( "I am partially in Zone", 120 )
    SmokeEveryUnit(GroupObject,SMOKECOLOR.Green)
  end )

SetGroupObject:ForEachGroupNotInZone( Zone,
  function( GroupObject )
    GroupObject:MessageToAll(  "I am not in Zone", 120 )
    SmokeEveryUnit(GroupObject,SMOKECOLOR.Orange)
  end )
