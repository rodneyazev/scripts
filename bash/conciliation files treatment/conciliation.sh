#!/bin/bash
#
# Script name: conciliation.sh
# Description: Portfolio feed file

# Dates details
FILE_DATE=`TZ=GMT+24 date +%Y-%m-%d_%a-%B`
BACKUP_DATE=`TZ=GMT+48 date +%Y-%m-%d`
FILE_DATE_KER=`TZ=GMT+24 date +%Y%m%d`
FILE_DATE_PORT=`TZ=GMT+24 date +%m-%d-%Y`

# Directories Path
DIR_FILES=/suportedbdc/odi/oracledi/datapro/file

DIR_LOGS=$DIR_FILES/logs
DIR_TEMP=$DIR_FILES/temp
DIR_BACKUP=$DIR_FILES/backup

# directories
DIR_FILES=$DIR_FILES/
DIR_FILES_HEALTH_CHECK_FILE_HIST=$DIR_LOGS/health_check.hist

# Server authentication details
SERVER_USER=root

SERVER=192.168.0.1
SERVER_FILES=/REC_PORT*$FILE_DATE_PORT*.txt
SERVER_FILES_PATH=/suportedbdc/BatchServer2.2/FeedFiles/in/processed

 GET_FILES=$SERVER_USER@$SERVER:$SERVER_FILES_PATH/$SERVER_FILES

PORTFOLIO_CHECK="grep REC_PORTFOLIO_DLY*.txt $DIR_FILES_HEALTH_CHECK_FILE_HIST"

#
# Generate folders if don't exist
#

if [ ! -d $DIR_FILES ]; then
	mkdir -p $DIR_FILES
fi

if [ ! -d $DIR_LOGS ]; then
	mkdir -p $DIR_LOGS
fi

if [ ! -d $DIR_TEMP ]; then
	mkdir -p $DIR_TEMP
fi

if [ ! -d $DIR_FILES ]; then
	mkdir -p $DIR_FILES
fi

if [ ! -d $DIR_BACKUP ]; then
	mkdir -p $DIR_BACKUP
fi

####################### PORTFOLIO files #######################


if [ -d $DIR_FILES ]; then

	echo Start getting Portfolio file from $FILE_DATE ...
	cd $DIR_FILES
	echo Current directory: $(pwd)
	
	if [ ! -d $DIR_TEMP ]; then
		mkdir $DIR_TEMP
	fi
	
	echo -ne "Connecting to Server ... $(scp -q $ GET_FILES $DIR_TEMP)"

	if [ $? -eq 0 ]; then

		echo Connected. 
		echo files download ... Done.
		
		echo -n "Validating files ... "
		
		if [ -d $DIR_TEMP ]; then
			mv `ls -tr $DIR_TEMP/REC_PORTFOLIO_DLY*.txt | head -1` $DIR_FILES
			rm -f $DIR_TEMP/*
		fi

		if [ ! -f $DIR_FILES_HEALTH_CHECK_FILE_HIST ]; then
			echo Done.

			touch $DIR_FILES_HEALTH_CHECK_FILE_HIST
			ls -p | grep -v / > $DIR_FILES_HEALTH_CHECK_FILE_HIST
			
			mv REC_PORTFOLIO_DLY*.txt PORTFOLIO.txt 2>/dev/null

		else

			if [[ $($PORTFOLIO_CHECK) ]]; then
                		echo Files already processed.
				if [ -d $DIR_FILES ]; then
					rm -f $DIR_FILES/*.txt
					rm -f $DIR_FILES/*.bad
                    rm -r $DIR_FILES/*.error
                fi
				exit 0	
			else
				echo -n "Backup previous files ... "
					tar -cf $BACKUP_DATE.tar *.txt
					gzip -qf $BACKUP_DATE.tar
					mv $BACKUP_DATE.tar.gz ../backup/ 2>/dev/null
				echo Done.

				echo -n "Deleting previous files ... "
				
				if [ -d $DIR_FILES ]; then
                    rm -f $DIR_FILES/PORTFOLIO.txt
					rm -f $DIR_FILES/*.bad
                    rm -r $DIR_FILES/*.error
                fi
				echo Done.

				touch $DIR_FILES_HEALTH_CHECK_FILE_HIST
				ls -p | grep -v / > $DIR_FILES_HEALTH_CHECK_FILE_HIST

				echo -n "Renaming files ... "
					mv REC_PORTFOLIO_DLY*.txt PORTFOLIO.txt 2>/dev/null
				echo Done.	
			fi	
		fi
	else
		echo Connection failed or files not found.
	fi
	echo End getting conciliation files ... Success.
	exit 0
else
	echo Directory $DIR_FILES not found.
fi
