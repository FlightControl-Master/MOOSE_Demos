---
-- Author: FlightControl
-- Created: 25.03.2017
-- Contributors: kaltokri
-- Modified: 24.02.2024
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Wrapper.Group.html
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Core.Scheduler.html
--
-- # Description:
--
-- Three air units are flying and are commanded to return a specific airbase.
--
-- # Guide:
-- 1. Observe group Air1 will return to Batumi after 10 seconds.
-- 2. Observe group Air2 will return to Kobuleti after 300 seconds.
--    - It was planned to land at Kutaisi in mission editor.
-- 3. Observe group Air3 will return to the home (landing) airbase after 300 seconds.
--    - It was planned to land at Kutaisi in mission editor.

--- Function to send RouteRTB command to the group
-- @param Wrapper.Group#GROUP AirGroup
function ReturnToBatumi( AirGroup )
  AirGroup:MessageToAll("ReturnToBatumi", 30)
  AirGroup:RouteRTB( AIRBASE:FindByName("Batumi") )
end

--- Function to send RouteRTB command to the group
-- @param Wrapper.Group#GROUP AirGroup
function ReturnToKobuleti( AirGroup )
  AirGroup:MessageToAll("ReturnToKobuleti", 30)
  AirGroup:RouteRTB( AIRBASE:FindByName("Kobuleti") )
end

--- Function to send RouteRTB command to the group
-- @param Wrapper.Group#GROUP AirGroup
function ReturnToHome( AirGroup )
  AirGroup:MessageToAll("ReturnToHome", 30)
  AirGroup:RouteRTB()
end

-- Get needed group objects:
Air1Group = GROUP:FindByName( "Air1" )
Air2Group = GROUP:FindByName( "Air2" )
Air3Group = GROUP:FindByName( "Air3" )

-- Setup different schedulers:
Scheduler = SCHEDULER:New( nil )
ScheduleIDAir1 = Scheduler:Schedule(nil, ReturnToBatumi,   { Air1Group }, 10 )
ScheduleIDAir2 = Scheduler:Schedule(nil, ReturnToKobuleti, { Air2Group }, 300 )
ScheduleIDAir3 = Scheduler:Schedule(nil, ReturnToHome,     { Air3Group }, 300 )

-- Inform player about the schudule:
Air1Group:MessageToAll("Air1 will RTB to Batumi in 10 seconds", 30 )
Air2Group:MessageToAll("Air2 will RTB to Kobuleti in 300 seconds (~12:05:00)", 60 )
Air3Group:MessageToAll("Air3 will RTB to Kutaisi in 300 seconds (~12:05:00)", 60 )
