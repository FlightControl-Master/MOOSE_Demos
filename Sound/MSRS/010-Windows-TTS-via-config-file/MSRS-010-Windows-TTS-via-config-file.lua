---
-- Author: FunkyFranky
-- Created: 24.12.2023
-- Contributors: kaltokri
-- Modified: 17.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Sound.SRS.html
--
-- # Description:
--
-- This is a simple demo mission that shows how to use the MSRS class to provide text-to-speech via SRS.
-- Therefore, you need to have the SRS client and server installed and running on your system.
-- The parameters should be taken from a config file "Moose_MSRS.lua", which is included in the demo directory.
-- The config file is automatically loaded when Moose is loaded.
-- So you do not need to worry about it in your mission script.
--
-- # Guide:
-- 1. You need to copy "Moose_MSRS.lua to your "Saved Games/DCS/Config/" directory and adjust the necessary parameters.
--    a. In particular, you need to set the path where SRS is installed on your system.
--    b. Also the voice used will be "Microsoft Hazel Desktop".
--       You need to either install that on your windows system or change it to a voice you have installed.
-- 2. You can either use the SRS AWACS overlay or just enter the F/A-18C Hornet client to listen the transmission.

-- Create a new MSRS instance. Frequency is 305 MHz AM(=0).
-- The first parameter (nil) is the SRS installation path. This is taken from the Moose_MSRS.lua config file.
local msrs = MSRS:New(nil, 305.00, 0)

-- Broadcast text after 5 seconds.
msrs:PlayText("Hello World, this is the Moose simple radio text-to-speech class speaking.", 5)
