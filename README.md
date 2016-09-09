# libamt
Build Windows AMT CIM Classes for Linux

## Summary

Intel provides usefull remote managment features in their bussiness
desktop chipsets, which they call "Active Management Technologie".

https://en.wikipedia.org/wiki/Intel_Active_Management_Technology

http://www.intel.com/technology/platform-technology/intel-amt/

For creating own software Intel offers an SDK. 

This SDK contains Code for Windows and Linux. 
Sadly, the Linux code is much older and does not utilize modern C++
code. Most of the code is pure C++ code. Why do not try to compile
this on Linux. This is the result and gole of this project.

## Get the AMT SDK

Because the SDK Code is not allowed to be redistributed, you have to 
download it by yourself.

https://software.intel.com/en-us/amt-sdk/download

After clone this repository, create a directory parallel to the libamt
dirctory called 'sdk'. Unzip the Intel zip file in sdk

You will have

  ./libamt
  ./sdk/DOCS
       /Linux
       /Windows
       ...
       
## Copy the files into libamt

Because we will patch some of them, you need to copy the source
file of the AMD SDK.

    $ cd libamt
    $ cp -r ../sdk/Windows/Common/SyncLib/Include SyncLib
    $ cp -r ../sdk/Windows/Common/SyncLib/src SyncLib


## Install dependencies

Along the normal C++ compiler, you we use the system libwsman and 
libxerces packages.

apt-get install libopenwsman-dev libxerces-c-dev
