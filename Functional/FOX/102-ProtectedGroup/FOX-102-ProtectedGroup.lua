---
-- Author: kaltokri
-- Created: 28.02.2024
-- Contributors: -
-- Modified: 28.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Functional.Fox.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
--
-- # Description:
-- In this mission we run a Functional FOX Missile trainer and add a protected group.
-- Note: AddProtectedGroup works only for AI!
--
-- # Guide:
-- 1. Start the mission.
-- 4. First AI aircraft is not protected and will be damaged or killed.
-- 5. Second AI aircraft is protected and will not be damaged.

-- Create a new missile trainer object.
fox=FOX:New()

-- Add protected AI group.
fox:AddProtectedGroup( GROUP:FindByName("Protected") )

-- Start missile trainer.
fox:Start()
MESSAGE:New( "FOX missile trainer started", 25, "INFO" ):ToAll():ToLog()
