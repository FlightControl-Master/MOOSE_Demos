---
-- Author: FlightControl
-- Created: 20.10.2018
-- Contributors: kaltokri
-- Modified: 22.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Beacon.html
--
-- # Description:
--
-- This test mission demonstrates the BEACON class.
-- The goal is to activate 2 types of beacons:
--   - One TACAN beacon attach to an aircraft.
--   - And one generic radio beacon attach to a ground UNIT (ADF).
--
-- The player aircraft needs to be ASM and TACAN compatible.
-- Please replace the A-10CII by an aircraft you own and that is able receive TACAN signals.
--
-- Please note that we added the Morse.ogg file with a SOUND TO COUNTRY action and the first MISSION START trigger.
-- Because there is no unit from Bulgaria in the mission, nobody will hear the sound. But ths way the file is part of
-- the mission file and we can use it with MOOSE.

-- # Guide:
-- 1. Enter A-10CII.
-- 2. Tune in 252 on UHF radio. You will hear the morse code.
-- 2. Switch UHF mode to ADF
-- 3. Needle 1 will move to ~ 150° on HSI.
-- 4. Switch back to BOTH and frequency 252 to avoid the beacon sound.
-- 5. Set TACAN to A/A REC and channel to 67Y (4 + 63).
-- 6. On NMSP activate TCN.
-- 7. HSI should point to the moving aircraft (but this seems to be brocken at the moment).

-- Activates tracing if you want to see in the log what BEACON does.
BASE:TraceClass("BEACON")
BASE:TraceLevel(3)

-- Create our UNIT objects on which we'll attach a BEACON.
local Aircraft = UNIT:FindByName("Unit1")
local LandUnit = UNIT:FindByName("Unit2")

-- Now, let's start with the TACAN Beacon.
-- Note that they are limited to Y band. Notice also that this particular TACAN can be homed on.
local BeaconAircraft = Aircraft:GetBeacon()
BeaconAircraft:AATACAN(4, "UNIT1", true)

-- And let's setup the ground based radio beacon (ADF).
-- Notice how this beacon will stop in 320 sec (last parameter).
local BeaconLand = LandUnit:GetBeacon()
BeaconLand:RadioBeacon("Morse.ogg", 252, radio.modulation.AM, 100, 320) -- File, frequency, modulation, power, timeout
