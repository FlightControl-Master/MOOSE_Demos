---
-- Author: kaltokri
-- Created: 28.02.2024
-- Contributors: -
-- Modified: 28.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Functional.Fox.html
--
-- # Description:
-- In this mission we run a Functional FOX Missile trainer and add a launch zone.
-- Change client to another aircraft in mission editor as required.
-- Change fox parameters with F10 radio menu.
--
-- # Guide:
-- 1. Start the mission and join the Su-25T as player.
-- 2. Activate auto pilot with key A.
-- 3. Switch to external view (F2).
-- 4. When the aircraft is passing the SA-13 it will fire a rocket.
-- 5. The rocket will explode prior reaching your aircraft, because the SAM site is placed within FOX_Launch_Zone.
-- 6. Fly straight ahead and the second SA-13 will start a missile that will kill you.
-- 7. The second SA-13 is not within the FOX_Launch_Zone. So it's missiles will not be handled by FOX.
--
-- NOTE:
-- Take a look at the triggers! This time we start the mission script with "4 MISSION START" and no CONDITION.
-- Functional.FOX can handle only objects, that are created after it is started.
--
-- If you change the trigger to "1 ONCE" with "TIME MORE 1" and join directly into Su-25T, you will not be protected!
-- Instead join as GAME MASTER blue first and wait for the "...started" message.
-- Switch to client (Su-25T) and you will be protected.

-- Create a new missile trainer object.
fox=FOX:New()

-- Add training Launch zones. Only launches from these zones are handled, if defined
fox:AddLaunchZone( ZONE:New("FOX_Launch_Zone") )

-- Start missile trainer.
fox:Start()
MESSAGE:New( "FOX missile trainer started", 25, "INFO" ):ToAll():ToLog()
