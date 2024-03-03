---
-- Author: Targs35 (from 62nd Air Wing) & FlightControl
-- Created: 11.01.2021
-- Contributors: kaltokri
-- Modified: 26.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Point.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Spawn.html
--
-- # Description:
-- A tanker will start from Sochi-Adler.
-- Two F-15C will also start from Sochi-Adler and join the tanker as escort.
--
-- # Guide:
-- 1. Start the mission and wait some seconds
-- 2. Press F2/F10 to observe the aircrafts
-- 3. Use time acceleration to shorten waiting times

-- Create Spawn Groups
local Tanker_Texaco = SPAWN:New( "Tanker_Texaco_Droge" )
                           :InitLimit( 1, 10 )
                           :InitCleanUp( 240 )
                           :SpawnScheduled( 60, .0 )

local Escort_Texaco_1 = SPAWN:New( "Escort_Texaco_F15C-1" )
                             :InitLimit( 1, 20 )
                             :InitCleanUp( 240 )
                             :SpawnScheduled( 120, .1 )

local Escort_Texaco_2 = SPAWN:New( "Escort_Texaco_F15C" )
                             :InitLimit( 1, 20 )
                             :InitCleanUp( 240 )
                             :SpawnScheduled( 120, .2 )

-- Spawn Groups into world
local GroupTanker_Texaco   = Tanker_Texaco:Spawn()
local GroupEscort_Texaco_1 = Escort_Texaco_1:Spawn()
local GroupEscort_Texaco_2 = Escort_Texaco_2:Spawn()

-- Define the distance from Tanker to Escort
local PointVec1 = POINT_VEC3:New( -100, 20, 80  ) -- This is a Vec3 class.
local PointVec2 = POINT_VEC3:New( -100, 20, 150  ) -- This is a Vec3 class.

-- Define Escort tasks
local FollowDCSTask1 = GroupEscort_Texaco_1:TaskFollow( GroupTanker_Texaco, PointVec1:GetVec3() )
local FollowDCSTask2 = GroupEscort_Texaco_2:TaskFollow( GroupTanker_Texaco, PointVec2:GetVec3() )
GroupEscort_Texaco_1:SetTask( FollowDCSTask1, 1 )
GroupEscort_Texaco_2:SetTask( FollowDCSTask2, 2 )

MESSAGE:New( "Tanker_Texaco Loaded", 25 ):ToAll()
