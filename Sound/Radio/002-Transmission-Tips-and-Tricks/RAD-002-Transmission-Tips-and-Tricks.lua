---
-- Author: FlightControl
-- Created: 20.10.2018
-- Contributors: kaltokri
-- Modified: 22.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Sound.Radio.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Event.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Scheduler.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Timer.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
--
-- # Description:
--
-- This test mission demonstrates the RADIO class in a more complex scenario.
-- It also focuses on how to create transmissions faster and more efficiently.
-- Please Read and try the other radio example mission first.
--
-- The Player is in a Su-25T parked on Batumi.
-- A Russian command center named "Batumi Tower" placed near Batumi will act as Batumi's Radio Tower.
-- This mission also features the "Viktor" flight, a Russian Su-25, who is inbound for landing on Batumi.
-- The goal of this script is to manage the dialog between Viktor and Batumi Tower.
--
-- In an older version all radio calls was done by delays. But behaviour of ai units may change on in future.
-- Some we changed the mission to check if the plane is within the 5km zone and to check for the event land.
--
-- The (short) conversation between Viktor and Batumi Tower will happen on 115 AM.
-- Start  +10 : Batumi Tower  "Viktor flight, this is Batumi Tower, enter left base runway one two five, report 5 kilometers final. Over."
-- Start  +20 : Viktor        "Report 5 kilometers final, one two five, viktor"
-- InZone     : Viktor        "Batumi Tower, Viktor is 5 kilomters final, request landing clearance. Over?"
-- InZone +10 : Batumi Tower  "Viktor flight, you are claer to land, runway one two five. Check gear down."
-- InZone +17 : Viktor        "Clear to land, One two five, Viktor"
-- Land    +2 : Viktor        "Viktor, touchdown"
-- Land    +7 : Batumi Tower  "Viktor, confirmed touchdown, taxi to parking area, Batumi Tower out."
--
-- # Guide:
--
-- 1. Enter the Su-25T and listen to the radio.
-- 2. After Viktor has left the runway you can end the mission.

-- Get all needed objects.
BatumiRadio = STATIC:FindByName("Batumi Tower"):GetRadio()
Viktor      = UNIT:FindByName("Viktor")
ViktorRadio = Viktor:GetRadio()
ZoneToCheck = ZONE:New( "Zone5km" )
ZoneToCheck:DrawZone() -- Show the zone in F10 map, so it is easy to see.

-- Let's first explore different shortcuts to setup a transmission before broadcastiong it.
------------------------------------------------------------------------------------------------------------------------------------------------------
-- First, the long way, using several lines of code.
BatumiRadio:SetFileName("Batumi Tower - Enter left base.ogg")
BatumiRadio:SetFrequency(115)
BatumiRadio:SetModulation(radio.modulation.AM)
BatumiRadio:SetPower(100)

-- Every RADIO:SetXXX() function returns the radio, so we can rewrite the code above to look like this:
BatumiRadio:SetFileName("Batumi Tower - Enter left base.ogg"):SetFrequency(115):SetModulation(radio.modulation.AM):SetPower(100)

-- We can also use the shortcut RADIO:NewGenericTransmission() to set multiple parameters in one function call.
-- If our broadcaster was a UNIT or a GROUP, the more appropriate shortcut to use would be NewUnitTransmission()
-- Note: NewUnitTransmission() will work for both UNIT and GROUP objects, despite its name!
BatumiRadio:NewGenericTransmission("Batumi Tower - Enter left base.ogg", 115, radio.modulation.AM, 100)

-- If you already set some parameters previously, you don't have to redo it.
-- NewGenericTransmission's paramter have to be set in order.
BatumiRadio:NewGenericTransmission("Batumi Tower - Enter left base.ogg", 115) -- Modulation is still AM and power is still 100 (set previously).

-- You can mix the format if you want. This will still work:
BatumiRadio:NewGenericTransmission("Batumi Tower - Enter left base.ogg", 115):SetPower(100) 

-- Now is the time to broadcast it after 5 sec delay to avoid conflicts with a RTB radio call from Victor.
-- We use a simple SCHEDULER with an inline function:
CommunitcationScheduler = SCHEDULER:New( nil,
  function()
    BatumiRadio:Broadcast()
  end, {}, 10 -- 10s delay from mission script start.
)

-- If Viktor answered imedately, the two radio broadcasts would overlap. We need to delay Viktor's answer a little bit. 
CommunitcationScheduler = SCHEDULER:New( nil,
  function()
    ViktorRadio:SetFileName("Viktor - Enter left base ack.ogg"):SetFrequency(115):SetModulation(radio.modulation.AM):Broadcast() -- We don't specify a subtitle since we don't want one.
  end, {}, 20 -- 20s delay from mission script start.
)

-- We need a function to check if Viktor is within the 5km zone.
NeedToSendRequest = true -- We want to send it only once.

function checkZone()
  GroupToCheck = GROUP:FindByName( "Viktor Flight" )
  if GroupToCheck then
    if GroupToCheck:IsCompletelyInZone( ZoneToCheck ) and NeedToSendRequest then

      -- We only specify the new file name, since frequency and modulation didn't change.
      ViktorRadio:SetFileName("Viktor - Request landing clearance.ogg"):Broadcast()

      -- The request is send, so we skip it from now on when function is triggered.
      NeedToSendRequest = false

      -- After reaching the 5km zone we start a timer to wait 10 seconds and send the next message.
      TIMER:New(
        function()
          BatumiRadio:SetFileName("Batumi Tower - Clear to land.ogg"):Broadcast()
        end
      ):Start(10) -- 10s delay after reaching zone.

      -- After reaching the 5km zone we start a timer to wait 17 seconds and send the answer.
      TIMER:New(
        function()
          ViktorRadio:SetFileName("Viktor - Clear to land ack.ogg"):Broadcast()
        end
      ):Start(17) -- 17s delay after reaching zone.
    end
  end
end

-- We need a timer to check regularly if the plane is within 5 km using the function checkZone defined above.
checkZoneTimer = TIMER:New( checkZone )
-- Start timer after 10 seconds and repeat the check every 1 second.
checkZoneTimer:Start(10, 1)

-- To send radio calls after landing, we use EVENTS:
Viktor:HandleEvent( EVENTS.Land )

function Viktor:OnEventLand( EventData )
  TIMER:New(
    function()
      ViktorRadio:SetFileName("Viktor - Touchdown.ogg"):Broadcast()
    end
  ):Start(2) -- 2s delay after touchdown.
  TIMER:New(
    function()
      BatumiRadio:SetFileName("Batumi Tower - Taxi to parking.ogg"):Broadcast()
    end
  ):Start(7) -- 7s delay after touchdown.
end
