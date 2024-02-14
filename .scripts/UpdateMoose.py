"""
This script finds all miz files and updates the contained Moose.lua from a given one.

It also extracts the contained mission script and places it next to the miz file.
All files that end with lua and do NOT start with Moose are extracted.

This script is supposed to be run from, e.g., github actions when a new demo mission is
uploaded.
"""

from multiprocessing.util import is_exiting
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
from shutil  import rmtree, copy
import argparse
import filecmp
import urllib.request
import os

def findMoose(path: Path):
    # Loop over all lua files (recursively)
    for f in path.rglob("*.lua"):
        if f.name.lower().startswith("moose"):
            print(f"Found Moose file as: {f}")
            return f

def copyScripts(path: Path, topath):
    # Loop over all lua files (recursively)
    print('Copy all lua files to parent folder')
    for f in path.rglob("*.lua"):
        if not (f.name.lower().startswith("moose")):
            print(f"Found script: {f}")
            copy(f, topath)

def update(f: Path, MooseLuaDev: Path, MooseLuaMaster: Path, Temp: Path, UpdateMoose: bool):
    """
    Update the Moose.lua file in given file.
    """
    # Print file name.
    print(f"Checking file: {f}")

    # Extract all the contents of zip file in different directory
    with ZipFile(f, mode='r') as miz:
        miz.extractall(Temp)
        print('MIZ extracted to {}'.format(Temp))

    # Folder where script is located
    ScriptDir=Temp/"l10n/DEFAULT/"

    # Check if that directory exists! GRP-600 - Respawn.miz was faulty
    if not ScriptDir.is_dir():
        print(f"WARNING: {ScriptDir.name} does not exit!")
        return

    # Copy all script files (all files that do NOT start with moose and end with lua)
    copyScripts(ScriptDir, f.parent)

    if UpdateMoose:
        # Find old Moose file in Script directory.
        MooseOld=findMoose(ScriptDir)
        if not MooseOld.is_file():
            print("WARNING: Could not find any file that starts with Moose!")
            return

        if 'master' in os.path.basename(f):
            print('This mission needs Moose_.lua from master branch')
            MooseLua = MooseLuaMaster
        else:
            MooseLua = MooseLuaDev

        # Check if Moose.lua file is up to date.
        if filecmp.cmp(MooseLua, MooseOld):
            print(f"INFO: {MooseOld.name} file is up-to-date ==> Nothing to do!")
        else:
            # Info.
            print(f"INFO: Updating {MooseOld.name} with current version")

            # Copy Moose.lua to temp dir.
            copy(MooseLua, MooseOld)

            # Create new miz file
            with ZipFile(f, mode='w', compression=ZIP_DEFLATED, allowZip64=False, compresslevel=9) as archive:
                for file_path in Temp.rglob("*"):
                    archive.write(file_path, arcname=file_path.relative_to(Temp))

    # Remove temp dir.
    print( 'Removing temp folder' )
    try:
        rmtree(Temp)
    except:
        pass

    # Debug info.
    if False:
        with ZipFile(f, mode='r') as zipObj:
            zipObj.printdir()
            #for filename in zipObj.namelist():
            #    print(filename)

    # Done.
    print("--------------")

if __name__ == '__main__':

    # Command line argument parser.
    parser = argparse.ArgumentParser(description='Blabla.')

    # Add argument for Moose path.
    parser.add_argument('--MoosePath', metavar='moose', type=str, help='path to Moose.lua file', default="./")

    # Add argument for Moose path.
    parser.add_argument('--MissionPath', metavar='missions', type=str, help='path to missions', default="../")

    #
    parser.add_argument('--UpdateMoose', action='store_true')

    # Execute the parse_args() method
    args = parser.parse_args()

    # Path to Moose.lua
    Moose=Path(args.MoosePath)

    print("MoosePath=" + args.MoosePath)
    print("MissionPath"+ args.MissionPath)
    if args.UpdateMoose:
        print("UpdateMoose is given. Moose_.lua files will be updated.")

    branch='develop'
    website = 'https://raw.githubusercontent.com/FlightControl-Master/MOOSE_INCLUDE'
    url = f'{website}/{branch}/Moose_Include_Static/Moose_.lua'

    # Moose.lua file
    MooseLua=Moose/"Moose_.lua"

    if not MooseLua.exists():
        urllib.request.urlretrieve( url, MooseLua)

    # Check that Moose.lua exists
    if MooseLua.exists():
        print("Moose_.lua exists")
        with open(MooseLua) as myfile:
            head = [next(myfile) for x in range(1)]
        print( '\nHeader:\n{}\n'.format(head) )
    else:
        print(f"{MooseLua.name} does not exist")
        quit()

    # Download Moose from master branch
    branch='master'
    url = f'{website}/{branch}/Moose_Include_Static/Moose_.lua'
    # Moose.lua file
    MooseLuaMaster=Moose/"Moose_master.lua"
    if not MooseLuaMaster.exists():
        urllib.request.urlretrieve( url, MooseLuaMaster)

    # Path to search for mission (miz) files
    Missions=Path(args.MissionPath)

    # Temp directory.
    Temp=Path("temp/")

    # Try to delete temp folder.
    if Temp.is_dir():
        rmtree(Temp)

    # Loop over all miz files (recursively)
    print("\nSearch and process MIZ files:\n----------")
    for f in Missions.rglob("*.miz"):
        update(f, MooseLua, MooseLuaMaster, Temp, args.UpdateMoose)
