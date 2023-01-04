#!/bin/bash

# Script name: light_dump.sh
# Description: Light dump file

# EXPORT ENVIRONMENT

export ORACLE_HOME=/brflcprddb/oracle/product/11.2.0.2
export EXPORT_FOLDER=/brflcprddb/oracle/admin/BRFLCPRD/dpdump

if [ ! -d $EXPORT_FOLDER ]; then
        mkdir -p $EXPORT_FOLDER
        echo "Directory recreated: $EXPORT_FOLDER"
        echo "Please, try generate dump file again."
else
	cd $EXPORT_FOLDER
	
	# Clean old files
	rm -f PROD*
	
	$ORACLE_HOME/bin/expdp PROD/PROD@PRD DUMPFILE=PROD_$(date +%Y%m%d).DMP DIRECTORY=DATA_PUMP_DIR FLASHBACK_TIME=SYSTIMESTAMP SCHEMAS=PB_PROD_SO EXCLUDE=TABLE:\"LIKE \'PBS_ERROR_LOG%\'\",TABLE:\"LIKE \'PBS_ORDER_APP_REJ_NOTIF%\'\",TABLE:\"LIKE \'PMS_PORTFOLIO_HOLDING_HIST_NIN%\'\",TABLE:\"LIKE \'S_UBS_XML_AUDIT%\'\",TABLE:\"LIKE \'AUDIT_TRAIL%\'\" LOGFILE=PROD_$(date +%Y%m%d).log ;
	echo "Compacting dump file. Please, stand by ..." ;
	bzip2 PROD_$(date +%Y%m%d).DMP 
	
	echo "Light Dump file generated successfully!"
	
fi
