---
-- Author: funkyfranky
-- Created: 05.02.2023
-- Contributors: kaltokri
-- Modified: 01.03.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Weapon.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
--
-- # Description:
--
-- An SPH M109 Paladin is doing target practice and tasks to fire one life shell at the old runway at Kobuleti.
--
-- We monitor the SHOT event and track the shell until it impacts.
--
-- The impact point is marked with red smoke and a mark on the F10 map is shown.
--
-- We also use a callback function "WeaponImpact", which is called when the shell has impacted
-- and check if the shell fell into a zone "X".
--
-- NOTE: It takes some time until the paladin will fire. Be patient or use time acceleration.

-- Some message on screen.
local text = "Starting Weapon Test mission"
MESSAGE:New( text, 120 ):ToLog():ToAll()

-- Create an event handler that monitors the SHOT event.
local handler = EVENTHANDLER:New()
handler:HandleEvent( EVENTS.Shot )

--- Function called when a tracked weapon impacts.
local function WeaponImpact( Weapon, Zone )
  local weapon = Weapon --Wrapper.Weapon#WEAPON
  local zone = Zone --Core.Zone#ZONE_RADIUS

  -- Get impact coordinate of weapon.
  local impactcoord = weapon:GetImpactCoordinate()

  if impactcoord then

    -- Check if impact was inside the target zone.
    local inzone = zone:IsCoordinateInZone( impactcoord )

    if inzone then
      -- Display message to all and in log file.
      MESSAGE:New( string.format( "Weapon %s impacted inside Zone %s! Well, done team of %s", weapon:GetTypeName(), zone:GetName(), weapon.launcherName ), 60 ):ToLog():ToAll()
    else
      -- Display message to all and in log file.
      MESSAGE:New( string.format( "Weapon %s impacted OUTSIDE Zone %s! Team of %s has to do some extra practice sessions", weapon:GetTypeName(), zone:GetName(), weapon.launcherName ), 60 ):ToLog():ToAll()
    end

  end
end

--- Function called on shot event.
function handler:OnEventShot( EventData )
  local eventdata = EventData --Core.Event#EVENTDATA

  -- Nil check if we have a weapon in the eventdata table.
  if eventdata and eventdata.weapon then

    -- Debug info.
    MESSAGE:New( string.format( "Captured SHOT Event from unit=%s", eventdata.IniUnitName ), 60 ):ToAll():ToLog()

    -- Create a new WEAPON object from the DCS weapon object in the event data.
    local weapon = WEAPON:New( eventdata.weapon )

    -- Mark impact point on F10 map.
    weapon:SetMarkImpact( true )

    -- Smoke impact point.
    weapon:SetSmokeImpact( true )

    -- Set function that is called on weapon impact. We also pass the zone as parameter to show how additional parameters are handled.
    weapon:SetFuncImpact( WeaponImpact, ZONE:FindByName( "X" ) )

    -- Start tracking the weapon.
    weapon:StartTrack()

  end

end

-- Active group.
GROUP:FindByName( "Paladin" ):Activate()
