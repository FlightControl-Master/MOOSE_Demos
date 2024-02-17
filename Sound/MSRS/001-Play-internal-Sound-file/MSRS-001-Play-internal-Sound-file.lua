---
-- Author: kaltokri
-- Created: 28.12.2023
-- Contributors: -
-- Modified: 17.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Sound.SRS.html
--
-- # Description:
--
-- This demo mission will play an internal audio file.
-- This is a file which is part of the .miz file.
-- If you don't own A-10CII you have to change the mission to use another aircraft and frequency.
--
-- Take a look at the ONCE trigger with name "Save Sound in Miz".
-- We use it to store the sound file within the mission, but it will never be played by this trigger, because the FLAG
-- with name Never is never set to true. This is usefull to thore single sound files. For a bit amount of sound files
-- another approch is needed (take a look at the ATIS class description).
--
-- # Guide:
--
-- 1. Enter the A-10CII and listen to the radio.

-- Check dcs.log if something is not working:
BASE:TraceClass("MSRS")
BASE:TraceClass("SOUNDFILE")
BASE:TraceLevel(3)
BASE:TraceOnOff( true )

FileName = "Hello-world.ogg"
FolderPath = nil -- Will use l10n/DEFAULT/ as default
Duration = nil -- Will use 3 seconds as default
UseSrs = true
InstallPathSrs = nil -- This will use the default installation path of SRS

-- If you did't install SRS into the default path uncomment and change the line below.
--InstallPathSrs = [[G:\Spiele\DCS\Tools\DCS-SimpleRadio-Standalone]]

local soundfile = SOUNDFILE:New(FileName, FolderPath, Duration, UseSrs)
local msrs = MSRS:New( InstallPathSrs, 251, radio.modulation.AM)

local function msg()
  MESSAGE:New( "I try to play the internal sound file now!" ):ToAll():ToLog()
  msrs:PlaySoundFile(soundfile)
end

-- Use a timer to delay the transmission 2 seconds after script is executeed.
-- Repeat transmission every 10 seconds.
TIMER:New( msg ):Start(2, 10)
