This repository will replace the [MOOSE_MISSION] repositry.
The [MOOSE_MISSION] repository has reached a hugh size (more then 22 GB).

This is because:
- There is a master and develop branch and all mission are saved twice.
- The mission files are saved without compression.
- On each commit the Moose_.lua is replaced in all mission files of the master branch.

A merge of master and develop branch is not possible because of the binary file type and the repository size.
This makes the [MOOSE_MISSION] repository hard to maintain. Each pull is a pain and takes far too long.

So we decided to create the new repository MOOSE_Demos and transfer the missions step by step.
- The missions are saved as compressed files
- We will only use one branch in that repository
- The Moose_.lua file will be replaced only once a week

I will compare missions from master and develop branch in [MOOSE_MISSION], test the missions and unify them.
After that I'll migrate them to MOOSE_Demos.
This will be a long running migration process, but will help to ease up maintenance of demo missions in future.

I'll start with demo missions of classes I already know, so I'm able to fix broken missions by myself.

[MOOSE_MISSION]: https://github.com/FlightControl-Master/MOOSE_MISSIONS
