---
-- FARPS
-- This demo shows how to dynamically spawn FARPs into a mission.
--
-- We spawn two FARPS in a zone near Batumi.
-- The first FARP is named "FARP Berlin" and the second "FARP London".
-- We put colored smoke on the spawned objects to mark them.
--
-- The data is taken from "template" FARPS. Note that if the same
-- name as the template is used, the original object is despawned
-- automatically when the new object is spawned.
--
-- As FARPS in DCS are strange creatures, which are hybrids of groups
-- and statics, the function :InitFARP is necessary.
---

-- Zone near Batumi on land.
local zoneSpawn1 = ZONE:FindByName( "SpawnZone1" )
local zoneSpawn2 = ZONE:FindByName( "SpawnZone2" )

-- Create a SPAWNSTATIC object from a template static FARP object.
local spawnStaticFarp = SPAWNSTATIC:NewFromStatic( "Static FARP Template-1", country.id.GERMANY )

-- Spawning FARPS is special in DCS. Therefore, we need to specify that this is a FARP.
-- We also set the call sign and the frequency.
spawnStaticFarp:InitFARP( CALLSIGN.FARP.Berlin, 130.000, 0 )

-- Spawn FARP with heading 90°. It's name will be "FARP Berlin".
local farpBerlin = spawnStaticFarp:SpawnFromZone( zoneSpawn1, 90, "FARP Berlin" )

-- Smoke static green.
farpBerlin:GetCoordinate():SmokeGreen()


-- The second FAPR gets call sign London and used radio frequency 131 MHz.
spawnStaticFarp:InitFARP( CALLSIGN.FARP.London, 131.000, 0 )

-- We set the country to UK.
spawnStaticFarp:InitCountry( country.id.UK )

-- Spawn the FARP at a random location inside the zone.
local FarpLondon = spawnStaticFarp:SpawnFromCoordinate( zoneSpawn2:GetRandomCoordinate(), nil, "FARP London" )

-- Put red smoke at FARP London.
FarpLondon:GetCoordinate():SmokeRed()


-- Function to check if the STATIC/AIRBASE objects can be found.
local function check()
  -- Try to find static.
  local staticBerlin = STATIC:FindByName( "FARP Berlin" )

  -- Launch red flare.
  staticBerlin:GetCoordinate():FlareRed()

  -- Get the airbase object and mark the parking spots.
  local AirbaseBerlin = AIRBASE:FindByName("FARP Berlin")
  AirbaseBerlin:MarkParkingSpots()
end

TIMER:New( check ):Start( 2, 5 )
