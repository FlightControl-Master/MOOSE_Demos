 -- Moose MSRS default Config
 MSRS_Config = {
  Path = [[C:\Program Files\DCS-SimpleRadio-Standalone]],   -- Path to SRS install directory.
  Port = 5002,            -- Port of SRS server. Default 5002.
  Backend = "srsexe",     -- Interface to SRS: "srsexe" or "grpc".
  Frequency = {127, 243}, -- Default frequences. Must be a table 1..n entries!
  Modulation = {0,0},     -- Default modulations. Must be a table, 1..n entries, one for each frequency!
  Volume = 1.0,           -- Default volume [0,1].
  Coalition = 0,          -- 0 = Neutral, 1 = Red, 2 = Blue (only a factor if SRS server has encryption enabled).
  Coordinate = {0,0,0},   -- x, y, alt (only a factor if SRS server has line-of-sight and/or distance limit enabled).
  Culture = "en-GB",
  Gender = "male",
  Voice = "Microsoft Hazel Desktop", -- Voice that is used if no explicit provider voice is specified.
  Label = "MSRS",   
  Provider = "win", --Provider for generating TTS (win, gcloud, azure, aws).
 
  -- Windows
  win = {
    voice = "Microsoft Hazel Desktop", -- Native Windows TTS engine. That voice needs to be installed on your system.
  },   
  -- Google Cloud
  gcloud = {
    voice = "en-GB-Standard-A", -- The Google Cloud voice to use (see https://cloud.google.com/text-to-speech/docs/voices).
    credentials=[[C:\Program Files\DCS-SimpleRadio-Standalone\yourfilename.json]], -- Full path to credentials JSON file (only for SRS-TTS.exe backend)
    key="Your access Key", -- Google API access key (only for DCS-gRPC backend)
  },
  -- Amazon Web Service
  aws = {
    voice = "Brian", -- The default AWS voice to use (see https://docs.aws.amazon.com/polly/latest/dg/voicelist.html).
    key="Your Access Key",  -- Your AWS key.
    secret="Your secret key", -- Your AWS secret key.
    region="eu-central-1", -- Your AWS region (see https://docs.aws.amazon.com/general/latest/gr/pol.html).
  },
  -- Microsoft Azure
  azure = {
    voice="en-US-AriaNeural",  --The default Azure voice to use (see https://learn.microsoft.com/azure/cognitive-services/speech-service/language-support).   
    key="Your access key", -- Your Azure access key.
    region="westeurope", -- The Azure region to use (see https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/regions).
  },
}