---
-- Author: kaltokri
-- Created: 08.06.2024
-- Contributors: -
-- Modified: -
--
-- # Documentation:
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Utilities.Utils.html##(UTILS).LoadFromFile
-- https://flightcontrol-master.github.io/MOOSE_DOCS_DEVELOP/Documentation/Utilities.Utils.html##(UTILS).SaveToFile
--
-- # Description:
-- DCS must be desanitized!
-- https://flightcontrol-master.github.io/MOOSE/advanced/desanitize-dcs.html
--
-- # Guide:
-- - Start the mission and choose role of GAME MASTER.
-- - Wait for the message about lfs and io.
-- - Open radio menu by pressing #, then choose "Other...".
-- - Activate "Load points from file".
-- - You will get an error message, because the file does not exist yet.
-- - Open menu again and activate "Show points". Both sides have 0 points.
-- - Go into menu and choose "Give 100 points to RED" -> Blue 0, Red 100.
-- - Now give blue 300 points by choosing "Give 100 points to BLUE" three times -> Blue 300, Red 100.
-- - Now use "Save points to file". A file will be created on your hard disk.
-- - Switch to the desktop and open the file with Notepad++ and take a look at the content. Close it.
-- - Switch back to DCS and choose "Reset points" -> Blue 0, Red 0.
-- - Activate "Load points from file" -> Blue 300, Red 100.
-------------------------------------------------------------------------


-- Define some configuration values
local fileNamePoints = "Demo-UTL-001-Save-and-Load-Data.txt"

-- Define some global variables
Points = {
  Blue = 0,
  Red  = 0
}

-- Show points of both coalition
function ShowPoints()
  local messageText = string.format("Mission points of both coalition:\nRED:   %04d\nBLUE: %04d", Points['Red'], Points['Blue'] )
  MESSAGE:New( messageText, 25, "INFO" ):ToAll():ToLog()
end

-- A function to give points to a coalition
function AddPoints(coalition, amount)
  local messageText = string.format("Adding %d points to coalition %s", amount, coalition)
  MESSAGE:New( messageText, 25, "INFO" ):ToAll():ToLog()
  Points[coalition] = Points[coalition] + amount
  ShowPoints()
end

function ResetPoints()
  MESSAGE:New( "Reseting points", 25, "INFO" ):ToAll():ToLog()
  Points['Blue'] = 0
  Points['Red'] = 0
  ShowPoints()
end

-- Save points to a file to make them persistent
function SavePointsToFile( fileName, folderPath )

  -- Create data string to be stored
  local data = string.format( "Red:%d;Blue:%d", Points['Red'], Points['Blue'] )

  local messageText = string.format("Saving points to file.\nPath: %s\nFile: %s\nData: %s", folderPath, fileName, data )
  MESSAGE:New( messageText, 25, "INFO" ):ToAll():ToLog()

  UTILS.SaveToFile( folderPath, fileName, data )
end

-- Load data from file and save it into the table Points.
-- You have to take care of the interpetation of the data yourself.
function LoadPointsFromFile( fileName, folderPath )

  local messageText = string.format("Loading points from file.\nPath: %s\nFile: %s", folderPath, fileName )
  MESSAGE:New( messageText, 25, "INFO" ):ToAll():ToLog()

  -- It returns a boolean and a table with one entry per line
  local outcome, data = UTILS.LoadFromFile( folderPath, fileName )

  -- Check if the loading was successful
  if outcome then
    -- We know our data is only 1 line, so data[1] is okay.
    -- If you save more complex data you need to iterate over each line!
    MESSAGE:New( "Raw data loaded from file: " .. data[1], 25, "INFO" ):ToAll():ToLog()

    MESSAGE:New( "Converting and sending into points table.", 25, "INFO" ):ToAll():ToLog()
    for key, value in string.gmatch(data[1], "(%w+):(%w+)") do
      Points[key] = value
    end
    ShowPoints()
  else
    MESSAGE:New( "Loading data from file failed", 25, "ERROR" ):ToAll():ToLog()
  end
end


-- Check if DCS is desanitized.
if lfs and io then
  MESSAGE:New( '*** lfs and io are desanitized = OK ***', 25, "INFO" ):ToAll():ToLog()

  -- We will use the Mission folder in your DCS Saved Games path.
  local missionFolderPath = lfs.writedir() .. 'Missions'

  -- Add menu entries to execute the functions
  MENU_MISSION_COMMAND:New( "Show points", nil, ShowPoints )
  MENU_MISSION_COMMAND:New( "Reset points", nil, ResetPoints )
  MENU_MISSION_COMMAND:New( "Give 100 points to RED",  nil, AddPoints, 'Red',  100 )
  MENU_MISSION_COMMAND:New( "Give 100 points to BLUE", nil, AddPoints, 'Blue', 100 )
  MENU_MISSION_COMMAND:New( "Save points to file", nil, SavePointsToFile, fileNamePoints, missionFolderPath )
  MENU_MISSION_COMMAND:New( "Load points from file", nil, LoadPointsFromFile, fileNamePoints, missionFolderPath )
else
  MESSAGE:New( '*** Your DCS is not desanitized. MOOSE is unable to use lfs and io! ***', 25, "ERROR" ):ToAll():ToLog()
end
