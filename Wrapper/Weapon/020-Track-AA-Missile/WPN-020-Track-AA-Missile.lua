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
-- An F-15C is tasked to shoot down a MiG-29 drone with an AIM-120B AMRAAM.
-- We monitor the SHOT event and track the missile until it impacts.
--
-- During the tracking, we monitor the current target of the missile and print out some parameters like
-- its speed and distance to the target to the DCS log file.
--
-- You will find that the missile does not have a target when lauched.
-- It will aquire the target after some time during flight, aka go "pitbull".
--
-- The impact point is marked with red smoke and a mark on the F10 map is shown.
---

-- Some message on screen.
local text = "Starting Weapon Test mission"
MESSAGE:New( text, 120 ):ToLog():ToAll()

-- Create an event handler that monitors the SHOT event.
local handler = EVENTHANDLER:New()
handler:HandleEvent( EVENTS.Shot )

--- Function called when a tracked weapon impacts.
local function WeaponTrack( Weapon )
  local weapon = Weapon --Wrapper.Weapon#WEAPON

  -- Get the target of the weapon.
  local target = weapon:GetTarget() --Wrapper.Unit#UNIT

  -- Get Speed of weapon.
  local speed = weapon:GetSpeed()

  -- Get target info.
  local targetName = weapon:GetTargetName()
  local targetDist = weapon:GetTargetDistance() or -100

  -- Write inofs to the dcs.log. Will create a lot of log lines!
  local text = string.format("T=%.3f: Tracking weapon Type=%s, speed=%.1f m/s, target=%s, dist=%.1f m", timer.getTime(), weapon:GetTypeName(), speed, targetName, targetDist )
  env.info( text )
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

    -- Set function that is called during tracking of the weapon.
    -- This function is called on every position update of the weapon, i.e very often!
    weapon:SetFuncTrack( WeaponTrack )

    -- Start tracking the weapon.
    weapon:StartTrack()
  end
end

-- Active group.
GROUP:FindByName("F-15C AA"):Activate()

-- Active target.
GROUP:FindByName("MiG-29 Drone"):Activate()
