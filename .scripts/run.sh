#!/bin/bash
cd "$(dirname "$0")"
python ./UpdateMoose.py --MoosePath ../../MOOSE_INCLUDE/Moose_Include_Static/ --MissionPath ../ --UpdateMoose
