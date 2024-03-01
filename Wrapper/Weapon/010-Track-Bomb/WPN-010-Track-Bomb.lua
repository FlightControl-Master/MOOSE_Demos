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
-- An F-15E is tasked to drop a Mk-82 bomb at the old airfield near Kobuleti.
-- We monitor the SHOT event and track the bomb until it impacts.
--
-- # Guide:
--
-- 1. Run the mission and watch the attack.
-- 2. The impact point is marked with red smoke and a mark on the F10 map

-- Some message on screen.
local text = "Starting Weapon Test mission"
MESSAGE:New( text, 120 ):ToLog():ToAll()

-- Create an event handler that monitors the SHOT event.
local handler = EVENTHANDLER:New()
handler:HandleEvent( EVENTS.Shot )

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

    -- Start tracking the weapon.
    weapon:StartTrack()
  end
end

-- Active group.
GROUP:FindByName( "F-15E" ):Activate()
