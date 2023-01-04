#!/bin/bash
#
# Script name: patrol_permission_fix.sh
# Description: Patrol Permission fix

# Directories path

DIR_POLICY=/var/oracle/odsee6/instances/policydir/logs
DIR_SHADOW=/var/oracle/odsee6/instances/shadowdir/logs
DIR_USERTEMP=/var/oracle/odsee6/instances/usertempdir/logs

# Generate folders if don't exist

if [ ! -d $DIR_POLICY ]; then
	mkdir -p $DIR_POLICY
fi

if [ ! -d $DIR_SHADOW ]; then
	mkdir -p $DIR_SHADOW
fi

if [ ! -d $DIR_USERTEMP ]; then
	mkdir -p $DIR_USERTEMP
fi

##############################################

if [ -d $DIR_POLICY ]; then
	chmod +r $DIR_POLICY/errors
fi

if [ -d $DIR_SHADOW ]; then
	chmod +r $DIR_SHADOW/errors
fi

if [ -d $DIR_USERTEMP ]; then
	chmod +r $DIR_USERTEMP/errors
fi

