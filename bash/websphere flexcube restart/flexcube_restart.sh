#!/bin/bash

# Script name: flexcube_restart.sh
# Description: Flexcube Restart


# Directories path

DIR_APP=/suportedbdc/WebSphere7/AppServer/profiles/wasprfnode

# Scripts restart application path

STOP_SERVER='/suportedbdc/WebSphere7/AppServer/profiles/wasprfnode/bin/stopServer.sh wasasmt00g -username user -password 12345'
STOP_NODE='/suportedbdc/WebSphere7/AppServer/profiles/wasprfnode/bin/stopNode.sh -username user -password 12345'
STOP_MANAGER='/suportedbdc/WebSphere7/AppServer/profiles/wasprfdmgr/bin/stopManager.sh -username user -password 12345'

START_MANAGER=/suportedbdc/WebSphere7/AppServer/profiles/wasprfdmgr/bin/startManager.sh
START_NODE=/suportedbdc/WebSphere7/AppServer/profiles/wasprfnode/bin/startNode.sh
START_SERVER='/suportedbdc/WebSphere7/AppServer/profiles/wasprfnode/bin/startServer.sh wasasmt00g'

# Scripts clean temp files

CLEAN_CLASS_FILES=/suportedbdc/WebSphere7/AppServer/profiles/wasprfnode/bin/clearClassCache.sh
CLEAN_OSGI_FILES=/suportedbdc/WebSphere7/AppServer/profiles/wasprfnode/bin/osgiCfgInit.sh

# Temp path

DIR_TEMP=$DIR_APP/temp
DIR_WSTEMP=$DIR_APP/wstemp
DIR_CONFIG_TEMP=$DIR_APP/config/temp


#
# Generate folders if don't exist
#

if [ ! -d $DIR_APP ]; then
	mkdir -p $DIR_APP
fi

if [ ! -d $DIR_TEMP ]; then
	mkdir -p $DIR_TEMP
fi

if [ ! -d $DIR_WSTEMP ]; then
	mkdir -p $DIR_WSTEMP
fi

if [ -d $DIR_CONFIG_TEMP ]; then
	mkdir -p $DIR_CONFIG_TEMP
fi

####################### FLEXCUBE APPLICATION #######################

if [ -d $DIR_APP ]; then
	
	$STOP_SERVER
	sleep 3

	$STOP_NODE
	sleep 3

	$STOP_MANAGER
	sleep 3

	echo " "	
	echo "Cleaning temp files ..."
      	echo " " 

	$CLEAN_CLASS_FILES
        sleep 3
        $CLEAN_OSGI_FILES
        sleep 3

	echo " "	

	if [ -d $DIR_TEMP ]; then
		cd $DIR_TEMP/
		rm -rf $DIR_TEMP/*
	fi

	if [ -d $DIR_WSTEMP ]; then
		cd $DIR_WSTEMP
		rm -rf $DIR_WSTEMP/*
	fi

	if [ -d $DIR_CONFIG_TEMP ]; then
		cd $DIR_CONFIG_TEMP
		rm -rf $DIR_CONFIG_TEMP/*
	fi

	$START_MANAGER
	sleep 3

	$START_NODE
	sleep 3

	$START_SERVER
	sleep 3

	echo " "	
	echo Flexcube Services Restarted.
	echo " "
fi