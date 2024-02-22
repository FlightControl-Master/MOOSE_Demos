---
-- Author: FlightControl
-- Created: 20.10.2018
-- Contributors: kaltokri
-- Modified: 22.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Sound.Radio.html
--
-- # Description:
--
-- This demo mission will play an internal audio file by using the RADIO class.
-- This is a sound file which is part of the .miz file.
--
-- Sender is a UNIT object (a MiG-29 = Wrapper.Unit#UNIT).
--  - See limitations in Sound.Radio documentation.
--  - It is placed above Kobuleti and is inbound for a landing on Batumi.
--
-- We added the free Su-25T parked on Batumi:
--   - It is doesn't have ASM (Advanced System Modelling).
--   - So you will hear every communication, whatever the frequency and the modulation is set to.
--   - No static noise or volume reduction will be applied.
--
-- We also added a F/A-18C on Batumi:
--   - It does have ASM. So you will hear the radio call only if frequency and modulation does match. 
--   - We set 305 AM in the mission, because it is the default setting of both F/A-18C radios.
--   - If you don't own F/A-18C you have to change the mission to use another aircraft, modulation and frequency.
--
-- Take a look at the ONCE trigger with name "Save Sound in Miz".
-- We use it to store the sound file within the mission, but it will never be played by this trigger, because the FLAG
-- with name Never is never set to true. This is usefull to thore single sound files. For a bit amount of sound files
-- another approch is needed (take a look at the ATIS class description).
--
-- # Guide:
--
-- 1. Enter the Su-25T and listen to the radio.
-- 2. At first you'll hear an standerd ATC radio call.
-- 3. After 10 seconds the script will be .
-- 4. Restart the mission and enter the F/A-18C.
-- 5. Note the difference in sound of the radio call compared with the Su-25T.

Sergey = UNIT:FindByName("Sergey")

-- Let's get a reference to Sergey's RADIO
SergeyRadio = Sergey:GetRadio()  

-- Now, we'll set up the transmission
SergeyRadio:SetFrequency(305)                  -- Set a frequency in MHz,
SergeyRadio:SetModulation(radio.modulation.AM) -- a modulation (we use DCS' enumartion, this way we don't have to type numbers)...
SergeyRadio:SetPower(100)                      -- and finally a power in Watts. A "normal" ground TACAN station has a power of 120W.
SergeyRadio:SetFileName("example.ogg")         -- Finally we set the name of the included soundfile.

-- Since Sergey is a UNIT, we can add a subtitle (displayed on the top left) to the transmission.
SergeyRadio:SetSubtitle("This is an example sound file played by MOSSE", 5)    -- The subtitle "Noise" will be displayed for 5 secs
SergeyRadio:SetLoop(false)                                                     -- UNITs can loop the transmission, but we decided to send it only once.

-- Notice that we didn't have to imput a power!
-- If the broadcater is a UNIT or a GROUP, DCS automatically guesses the power to use depending on the type of UNIT or GROUP.

-- We inform the player about the delayed playback.
MESSAGE:New( "The sound file will be played in 10 seconds" ):ToAll():ToLog()

-- Execute the Broadcast after 10 seconds delay to avoid conflicts with the standard ATC radio call.
local mytimer = TIMER:New(
  function()
    SergeyRadio:Broadcast()
  end
):Start(10)
