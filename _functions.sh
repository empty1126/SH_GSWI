#!/bin/sh

 ############################################################
#                                                            #
#  Gameserver Webinterface - v1.0                            #
#  (C) by Streamhousing - www.streamhousing.de               #
#							     #
#  Infos to Infos@Streamhousing.de                           #
#  Suggestions to Suggestions@Streamhousing.de		     #
#  Bugs to Bugs@Streamhousing.de                             #
#  Technical Suggestions to Technik@Streamhousing.de         #
#                                                            #
#  File.........: _functions.sh				     #
#  License......: GPLv2                                      #
#  Author.......: -emPTy [empty@Streamhousing.de]            #
#                 -Slic  [Slic@Streamhousing.de]             #
#  --------------------------------------------------------  #
#  Discription..: Script to administrate gameservers on the  #
#                 rootserver.                                #
#                 Script can:				     #
#                  -create and remove Gameservers            #
#                  -start, stop and restart Gameservers      #
#                  -create start, stop and restart scripts   #
#                  -install and remove modifications         #
#                                                            #
 ############################################################


if [[ `whoami` == "root"  ]];then
	echo "Es ist ziemlich unsicher das Script als root auszufueren."
	echo "Trotzdem fortfahren ? [N/j]";
	read YN
	if [ "$YN" == "N" ] || [ "$YN" == "n" ] || [ "$YN" == "" ];then
		exit
	fi
fi

MASTER_SRV=85.214.43.91/Files/
RR_DIR=Scripts/
PACKAGE_DIR=Files/
MOD_DIR=Packages/Mods/
DEBUGG=true
VERS=1.0

function logger() {

 ###############################################################
# Logger funktion, that we dont get all shit on the terminal.   #
# Logger funktion does log all into an additional file.         #
#  -WARN...........: Message will just echo'd into the log.	#
#  -ERROR..........: Similar to WARN.			   	#
#  -SYSTEM_ERROR...: Message will echo'd into the log		#
#   		     and the document will exiting.		#
#  -DEBUGG.........: If variable DEBUG is set to true,      	#
#             	     debugg-logg-message will be echo'd.   	#
#                                                  		#
#  -LOG_CLEAR......: All logfiles, will be deleted and 		#
#              	     a message will echo'd into the    		#	
#              	     new log file.                    		#
#                                                  		#
 ###############################################################

	TIME=`date +%H:%M:%S`;
        DATE=`date +%D`
	NOW=$(date +"%b-%d-%y")
        LOG_DIR=/var/log/gswi/
	LOG_FILE="$LOG_DIR/$NOW.log"

	if [ "$2" == "DEBUGG" ];then
        	if [ "$DEBUGG" == "true" ];then
			echo "$DATE $TIME DEBUGG: $1" >> $LOG_FILE
		fi
	elif [ "$2" != "DEBUGG" ];then
		echo "$DATE $TIME $2: $1" >> $LOG_FILE
	        if [ "$2" == "SYSTEM_ERROR" ];then
        	        exit 1
        	elif [ "$2" == "LOG_CLEAR" ];then
			rm $LOG_DIR/*.log >& "$LOG_DIR/logg_stderr"
			if [ -f "$LOG_DIR/logg_stderr" ];then
			
				if [[ `cat $LOG_DIR/logg_stderr` != "" ]];then
					echo "$DATE $TIME STD_ERR: `cat $LOG_DIR/logg_stderr`" >> $LOG_FILE
					rm "$LOG_DIR/logg_stderr"
				fi
			fi
	
			touch $LOG_FILE
			exit
		fi
	fi
}

function std_err() {
	if [ -f "$LOG_DIR/logg_stderr" ];then
        	if [[ `cat $LOG_DIR/logg_stderr` != "" ]];then
			echo -e "\033[1;31m$DATE $TIME STDERR: `cat $LOG_DIR/logg_stderr`\033[1;37m" >> $LOG_FILE
		fi
	
		echo -e "\033[1;31mExiting document, putted the error into loggfile: '$LOG_FILE'.\033[1;37m"

		rm $LOG_DIR/logg_stderr
		exit
	fi
}

function ausgabe() {

 ################################################
# This will just echo the text collored          #
 ################################################

        case "$2" in
                "blau") echo -e "\033[1;34m$1\033[1;37m" ;;
                "rot") echo -e "\033[1;31m$1\033[1;37m" ;;
                "gruen") echo -e "\033[1;32m$1\033[1;37m" ;;
                *) echo -e "\033[1;37m$1\033[1;37m" ;;
        esac
}

function help() {
 ################################################
# This will output our help, if required.        #
 ################################################
	
	ausgabe "Die Hilfe soll unser Script erklaeren" blau
	ausgabe "Das Script soll nicht, irg-welche MODS erklaeren" blau
	ausgabe "Neu-schreibe, afk" blau
	ausgabe " speater bin einkaufen" blau

	ausgabe "Zurueck zur Uebersicht ? [J/n]" rot
	read BACK

		if [ "$BACK" == "" ] || [ "$BACK" == 0 ] || [ "$BACK" == "j" ] || [ "$BACK" == "J" ];then
			logger "Return to main" "DEBUGG"
			sh interface.sh
		else
			logger "Exiting from help, without returning to main" "DEBUGG"
			exit 1
		fi

}


