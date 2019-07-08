CC = g++ -std=c++11 -g -fpic -DTHW_TRACE


OPENWSMAN_CLFAGS = $(shell pkg-config --cflags openwsman++)
OPENWSMAN_LIBS = $(shell pkg-config --libs openwsman++ openwsman) 
#
# Private openwsman library

#OPENWSMAN_CLFAGS = -I$(HOME)/include/openwsman -I$(HOME)/include/openwsman/cpp
#OPENWSMAN_LIBS = -L$(HOME)/lib64 -lwsman_clientpp -lwsman_curl_client_transport -lwsman -lwsman_client

XERCES_CFLAGS = $(shell pkg-config --cflags xerces-c)
XERCES_LIBS = $(shell pkg-config --libs xerces-c)

INCLUDE =   -I../../intel/include -I../../mof/include 
BOOSTLIB = -lboost_system
LIBS    =   -L../.. -lamt $(BOOSTLIB) $(XERCES_LIBS) $(OPENWSMAN_LIBS)


scan-network: main.cpp Makefile
	$(CC) $(INCLUDE) $(LINK_OPTS) -o $@ main.cpp $(LIBS)

