#! /bin/bash

sdkpath=../sdk

mkdir SyncLib
cp -r $sdkpath/Windows/Common/SyncLib/Include SyncLib
cp -r $sdkpath/Windows/Common/SyncLib/src SyncLib
mkdir intel
mkdir intel/src
mkdir intel/intel
cp ../sdk/Windows/Common/WS-Management/C++/CimFramework/include/*.h intel/include/
cp ../sdk/Windows/Common/WS-Management/C++/CimFramework/src/*.cpp intel/src/
cp ../sdk/Windows/Common/WS-Management/C++/CimFrameworkUntyped/include/*.h intel/include/
cp ../sdk/Windows/Common/WS-Management/C++/CimFrameworkUntyped/src/*.cpp intel/src/
mkdir mof
mkdir mof/include
mkdir mof/src
cp ../sdk/Windows/Common/WS-Management/C++/CimFramework/CPPClasses/Include/*.h mof/include/
cp ../sdk/Windows/Common/WS-Management/C++/CimFramework/CPPClasses/Src/*.cpp mof/src/
cp ../sdk/Windows/Common/WS-Management/C++/CimOpenWsmanClient/CimOpenWsmanClient.h intel/include/
cp ../sdk/Windows/Common/WS-Management/C++/CimOpenWsmanClient/CimOpenWsmanClient.cpp intel/src/

rm intel/src/cdecode.cpp
rm intel/src/cencode.cpp
rm intel/include/cdecode.h
rm intel/include/cencode.h
