#!/bin/bash
#
# Script name: conciliation_feed_files.sh
# Description: Conciliation feed files

CONCILIATION_SCRIPT_FOLDER=/root/operations/scripts/feedfiles/conciliation
BACKUP_FOLDER=/suportedbdc/odi/oracledi/datapro/file/backup

# HEALTH CHECK BACKUP FOLDER FILES SIZE

if [ $BACKUP_FOLDER ]; then
    cd $BACKUP_FOLDER
    FILES_QTD=$(ls -1 | wc -l)

    if [ $FILES_QTD -gt 300 ]; then
		rm "$(ls -t | tail -1)"
    fi
else
	echo "Backup folder not found." > backup_folder_error.log 
fi

# CONCILIATION FILES PROCESS
 
if [ $CONCILIATION_SCRIPT_FOLDER ]; then

	cd $CONCILIATION_SCRIPT_FOLDER

	# LAST PROCESS LOG
	nohup ./conciliation.sh > output.out
	echo " "
	
else
	echo "Scripts not found." > scripts_error.log 
fi
