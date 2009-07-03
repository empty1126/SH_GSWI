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


#if [[ `whoami` == "root"  ]];then
#	echo "Es ist ziemlich unsicher das Script als root auszufueren."
#	echo "Trotzdem fortfahren ? [N/j]";
#	read YN
#	if [ "$YN" == "N" ] || [ "$YN" == "n" ] || [ "$YN" == "" ];then
#		exit
#	fi
#fi

source _vars.sh
	  
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

	if [ "$2" == "DEBUGG" ];then
        	if [ "$DEBUGG" == "true" ];then
			echo "$DATE $TIME DEBUGG: $1" >> $LOG_FILE
		fi
	elif [ "$2" == "INFO" ] && [ "$3" == "START" ] ;then
		echo -e "\033[1;34m$DATE $TIME INFO: $1\033[1;37m" >> $LOG_FILE
	elif [ "$2" == "INFO" ] && [ "$3" == "END" ] ;then
		echo -e "\033[1;32m$DATE $TIME INFO: $1\033[1;37m" >> $LOG_FILE
	elif [ "$2" != "DEBUGG" ];then
		echo "$DATE $TIME $2: $1" >> $LOG_FILE
	        if [ "$2" == "SYSTEM_ERROR" ];then
        	        exit 1
        	elif [ "$2" == "LOG_CLEAR" ];then
			rm $LOG_DIR/*.log 
			touch $LOG_FILE
			exit
		fi
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
	clear

	ausgabe "Sprache/Language ?" blau
	ausgabe "1) Deutsch" blau
	ausgabe "2) English" blau
	read LANGUAGE

		if [ "$LANGUAGE" == 1 ];then
			clear

			ausgabe "#################################" gruen
			ausgabe "### Hilfemenu" gruen
			ausgabe "#################################" gruen
			echo ""
			ausgabe "Mit unserem Gameserver-Interface koennen Sie spielend liecht Gameserver installieren," blau
			ausgabe "deinstallieren, starten, stoppen und neustarten." blau
			ausgabe "Derzeit unterstuetzt das Interface folgende Spiele:" blau
			ausgabe "Desweiteren unterstuetzt das Interface noch viele Mod-Installationen." blau
			ausgabe "1)Counterstrike 1.6" gruen
			ausgabe "2)Counterstrike: Source" gruen
			ausgabe "3)Modinstallation" gruen
			read TYPE
			
				if [ "$TYPE" == 1 ];then
					ausgabe "Hilfe zu Counterstrike 1.6" blau
				elif [ "$TYPE" == 2 ];then
					ausgabe "Hilfe zu Counterstrike: Source" blau
				elif [ "$TYPE" == 3 ];then
					ausgabe "Hilfe zur Modinstallation" blau
				fi

 	                ausgabe "Zurueck zur Uebersicht ? [J/n]" rot
                        read BACK

                        if [ "$BACK" == "" ] || [ "$BACK" == 0 ] || [ "$BACK" == "j" ] || [ "$BACK" == "J" ];then
                                logger "Return to main" "DEBUGG"
                                sh interface.sh
                        else
                                logger "Exiting from help, without returning to main" "DEBUGG"
                                exit 1
                        fi

		elif [ "$LANGUAGE" == 2 ];then
			clear

                        ausgabe "#################################" gruen
                        ausgabe "### Helpcenter " gruen
                        ausgabe "#################################" gruen
                        echo ""
			ausgabe "With our Gameserver-Interface, you can install, deinstall, start, stop and restart" blau
			ausgabe "gameservers very simple." blau
                        ausgabe "At the moment, the interface can work with the following games:" blau
			ausgabe "More over, the interface can deal with many modification-installations." blau
                        ausgabe "1)Counterstrike 1.6" gruen
                        ausgabe "2)Counterstrike: Source" gruen
			ausgabe "3)Modinstallations" gruen
                        read TYPE

                                if [ "$TYPE" == 1 ];then
                                        ausgabe "Hilfe zu Counterstrike 1.6" blau
                                elif [ "$TYPE" == 2 ];then
                                        ausgabe "Hilfe zu Counterstrike: Source" blau
				elif [ "$TYPE" == 3 ];then
					ausgabe "Hilfe zur Modinstallation" blau
                                fi


			echo ""
                        ausgabe "Back to Overview ? [J/n]" rot
                        read BACK

                        if [ "$BACK" == "" ] || [ "$BACK" == 0 ] || [ "$BACK" == "j" ] || [ "$BACK" == "J" ];then
                                logger "Return to main" "DEBUGG"
                                sh interface.sh
                        else
                                logger "Exiting from help, without returning to main" "DEBUGG"
                                exit 1
                        fi

		fi

}


