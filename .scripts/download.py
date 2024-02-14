import urllib.request

urllib.request.urlretrieve('https://raw.githubusercontent.com/FlightControl-Master/MOOSE_INCLUDE/develop/Moose_Include_Static/Moose_.lua', '../.build/Moose_develop.lua')
urllib.request.urlretrieve('https://raw.githubusercontent.com/FlightControl-Master/MOOSE_INCLUDE/master/Moose_Include_Static/Moose_.lua',  '../.build/Moose_master.lua')
