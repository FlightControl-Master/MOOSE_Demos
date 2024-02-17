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
-- This demo mission will read an external text file.
-- This is a file which is not part of the .miz file.
-- If you don't own A-10CII you have to change the mission to use another aircraft and frequency.
--
-- # Guide:
--
-- 1. Save the file Hello-world.txt to your Missions folder,
--    e.g. C:\Users\<YourUserName>\Saved Games\DCS.openbeta\Missions.
-- 2. Enter the A-10CII and listen to the radio.

-- Check dcs.log if something is not working:
BASE:TraceClass("MSRS")
BASE:TraceLevel(3)
BASE:TraceOnOff( true )

-- Force to use SRSEXE and WINDOWS TTS, no matter what is defined in Moose_MSRS.lua
local msrs = MSRS:New()
msrs:SetBackendSRSEXE()
msrs:SetProvider(MSRS.Provider.WINDOWS)
msrs:SetFrequencies(251)

local fileName = "Hello-world.txt"
local folderPath = lfs.writedir() .. 'Missions'
local delay = 5

-- Broadcast text after 5 seconds.
MESSAGE:New( "I try to play the external text file now!" ):ToAll():ToLog()
msrs:PlayTextFile(string.format("%s\\%s", folderPath, fileName), delay)
