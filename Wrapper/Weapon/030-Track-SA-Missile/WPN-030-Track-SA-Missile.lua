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
-- An F-16CM Pilot lost control over his aircraft.
-- Unfortunately, his current course is guiding him directly towards an SA-10 site.
--
-- We monitor the SHOT event and track the missiles from the SAM site and use our latest secret weapon
-- (don't ask, it's really secret) to destroy the missiles before they reach the aircraft.

-- Some message on screen.
local text="Starting Weapon Test mission."
MESSAGE:New(text, 120):ToLog():ToAll()


-- Create an event handler that monitors the SHOT event.
-- NOTE that the event handler should be global here. If local, it gets garbage collected! Not sure why...
handler=EVENTHANDLER:New()
handler:HandleEvent(EVENTS.Shot)

--- Function called when a tracked weapon impacts.
local function WeaponTrack( Weapon )
  local weapon = Weapon --Wrapper.Weapon#WEAPON

  -- Get the target of the weapon.
  local target = weapon:GetTarget() --Wrapper.Unit#UNIT

  -- Get Speed of weapon.
  local speed = weapon:GetSpeed()

  -- Get type name of weapon.
  local typeName = weapon:GetTargetName()

  -- Get target info.
  local targetName = weapon:GetTargetName()
  local targetDist = weapon:GetTargetDistance() or -100


  -- Some info
  local text = string.format( "T=%.3f: Tracking weapon %s Type=%s, speed=%.1f m/s, target=%s, dist=%.1f m", timer.getTime(), weapon.name, typeName, speed, targetName, targetDist )
  env.info( text )

  if targetDist > 0 and targetDist < 100 then

    -- Message to screen.
    MESSAGE:New( string.format( "Destroying missile %s from %s", typeName, weapon.launcherName ), 60 ):ToAll():ToLog()

    -- Destroy weapon.
    weapon:Destroy()
  end
end

--- Function called on shot event.
function handler:OnEventShot( EventData )
  local eventdata = EventData --Core.Event#EVENTDATA

  -- Debug info.
  MESSAGE:New( string.format( "Captured SHOT Event from unit=%s", tostring( eventdata.IniUnitName ) ), 60 ):ToAll():ToLog()

  -- Nil check if we have a weapon in the eventdata table.
  if eventdata and eventdata.weapon then

    -- Debug info.
    MESSAGE:New( string.format( "Captured SHOT Event from unit=%s GOT WEAPON", tostring( eventdata.IniUnitName ) ), 60 ):ToAll():ToLog()

    -- Create a new WEAPON object from the DCS weapon object in the event data.
    local weapon = WEAPON:New( eventdata.weapon )

    -- Set function that is called during tracking of the weapon.
    -- This function is called on every position update of the weapon, i.e very often!
    weapon:SetFuncTrack( WeaponTrack )

    -- Small timer step.
    weapon:SetTimeStepTrack(0.005)

    -- Start tracking the weapon.
    weapon:StartTrack()
  end
end

-- Active group.
GROUP:FindByName("SA-10"):Activate()

-- Active group.
GROUP:FindByName("F-16 Flyby"):Activate()
