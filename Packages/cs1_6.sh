#!/bin/sh

 ############################################################
#                                                            #
#  Gameserver Webinterface - v1.0                            #
#  (C) by Streamhousing - www.streamhousing.de               #
#                                                            #
#  Infos to Infos@Streamhousing.de                           #
#  Suggestions to Suggestions@Streamhousing.de               #
#  Bugs to Bugs@Streamhousing.de                             #
#  Technical Suggestions to Technik@Streamhousing.de         #
#                                                            #
#  File.........: Packages/cs1_6.sh                          #
#  License......: GPLv2                                      #
#  Author.......: -emPTy [empty@Streamhousing.de]            #
#                 -Slic  [Slic@Streamhousing.de]             #
#  --------------------------------------------------------  #
#  Discription..: Script to administrate gameservers on the  #
#                 rootserver.                                #
#                 Script can:                                #
#                  -create and remove Gameservers            #
#                  -start, stop and restart Gameservers      #
#                  -create start, stop and restart scripts   #
#                  -install and remove modifications         #
#                                                            #
 ############################################################

source _functions.sh

TODO=$1
PORT=$2
GAME_PATH=$3
RR_FILE=../$RR_DIR/$PORT.sh

if [ "$TODO" == "install" ];then
	if [ "PORT" == "" ];then 
		logger "Es wurde kein Port angegeben." "ERROR"
		ausgabe "Port ?" rot
		exit 
	fi

	ausgabe "Bitte warten sie waehrend Counterstrike 1.6 mit Port: '$PORT' in '$GAME_PATH' installiert wird" gruen
	ausgabe "Dies kann einen Augenblick andauern." blau
		mkdir -p $GAME_PATH/$PORT/

		if [ "$?" != "0" ];then  
			logger "Es sind Fehler aufgetreten." "ERROR"
			ausgabe "Es sind Fehler aufgetreten." rot
			exit
		fi	

		if [ -f "$PACKAGE_DIR/cs1_6.tar" ];then
		        cp $PACKAGE_DIR/cs1_6.tar $GAME_PATH/$PORT/cs1_6.tar
       			cd $GAME_PATH/$PORT/
        		tar -xvf cs1_6.tar &>/dev/null
		else 
                        cd $PACKAGE_DIR
                        wget $MASTER_SRV/cs1_6.tar
        		cp cs1_6.tar $GAME_PATH/$PORT/cs1_6.tar
        		cd $GAME_PATH/$PORT/
        		tar -xvf cs1_6.tar &>/dev/null
		fi

		rm $GAME_PATH/$PORT/cs1_6.tar 

elif [ "$TODO" == "deinstall" ];then
	if [ "$PORT" == "" ];then
		logger "Es wurde kein Port angegeben." "ERROR"
		ausgabe "Port ?" rot
		exit
	fi

	ausgabe "Bitte warten sie waehrend Counterstrike 1.6 fuer Port: '$PORT' in '$GAME_PATH' deinstalliert wird." gruen
        ausgabe "Dies kann einen Augenblick andauern." blau


	cd $GAME_PATH
	rm -rf $PORT/

	if [ "$?" == 0 ];then
		ausgabe "Der Counterstrike 1.6-Server wurde erfolgreich deinstalliert." gruen
	else 
		logger "Es sind Fehler aufgetreten." "ERROR"
		ausgabe "Es sind Fehler aufgetreten." rot
		exit
	fi

elif [ "$TODO" == "start" ];then
        if [ "$PORT" == "" ];then
		logger "Es wurde kein Port angegeben." "ERROR"
	        ausgabe "Port ?" rot
		exit
	fi
	ausgabe "Versuche Gameserver mit Port: '$PORT' zu starten." blau 
	
	cd $RR_DIR
	sh $PORT.sh start		
	
	if [ "$?" != "0" ];then
		logger "Es sind Fehler aufgetreten." "ERROR" 
		ausgabe "Es sind Fehler aufgetreten." rot
		exit
	fi
		

elif [ "$TODO" == "stop" ];then
	if [ "$PORT" == "" ];then
		logger "Es wurde kein Port angegeben." "ERROR"
		ausgabe "Port ?" rot
		exit
	fi
	ausgabe "Versuche Gameserver mit Port: '$PORT' zu stoppen." blau

	cd $RR_DIR
	sh $PORT.sh stop
	
        if [ "$?" != "0" ];then
                logger "Es sind Fehler aufgetreten." "ERROR"
                ausgabe "Es sind Fehler aufgetreten." rot
                exit
        fi

elif [ "$TODO" == "restart" ];then
        if [ "$PORT" == "" ];then
		logger "Es wurde kein Port angegeben." "ERROR"
                ausgabe "Port ?" rot
                exit
        fi
        ausgabe "Versuche Gameserver mit Port: '$PORT' zu neuzustarten." blau

        cd $RR_DIR
        sh $PORT.sh restart

        if [ "$?" != "0" ];then
                logger "Es sind Fehler aufgetreten." "ERROR"
                ausgabe "Es sind Fehler aufgetreten." rot
                exit
        fi

elif [ "$TODO" == "build" ];then
                if [ "$PORT" == "" ];then
			logger "Es wurde kein Port angegeben." "ERROR"
                        ausgabe "Port ?" rot
                        exit
                fi
		cd $RR_DIR
			if [ -f "$RR_FILE" ];then
				rm $RR_FILE
			fi

			touch $RR_FILE

				if [ "$?" != "0" ];then
					logger "Es ist ein Fehler beim Erstellen der Startdatei aufgetreten." "ERROR"
					ausgabe "Es ist ein Fehler beim Erstellen der Startdatei aufgetreten." rot
					exit
				fi
			
			echo '#!/bin/sh' > $RR_FILE
			echo "NAME=$PORT" >> $RR_FILE
			echo 'DESK="gameserver"' >> $RR_FILE
			echo 'SCRIPT=hlds_run' >> $RR_FILE
			echo "DIR=$GAME_PATH/$PORT" >> $RR_FILE	
			ausgabe "Start-Map: [default: de_dust2]" blau
			read START_MAP
			
				if [ "$START_MAP" == "" ];then
				 	START_MAP="de_dust2"
				fi

			ausgabe "MAP: $START_MAP" gruen

			ausgabe "Maximale Spieleranzahl ?" blau
			read MAX_PLAYER

				if [ "$MAX_PLAYER" == "" ];then
					MAX_PLAYER=12
				fi

			ausgabe "MAXIMALE SPIELER: $MAX_PLAYER" gruen

			ausgabe "Tickrate des Servers ? [MAX 100]" blau
			read TICKRATE			

				if [ "$TICKRATE" != "" ];then
					if [ "$TICKRATE" -gt 100 ];then
						TICKRATE=100
					fi
				elif [ "$TICKRATE" == "" ];then
					TICKRATE=100

				fi

			ausgabe "TICKRATE: $TICKRATE" gruen

			ausgabe "Soll der Server automatisch durch Steam geupdatet werden ?" blau
			ausgabe "1)Ja" gruen
			ausgabe "2)Nein" gruen
			ausgabe "default: 1" gruen
			read AUTOUPDATE

				if [ "$AUTOUPDATE" == "" ];then
					AUTOUPDATE=1
				fi

				if [ "$AUTOUPDATE" == 1 ];then
					YN="AN"
				else
					YN="AUS"
				fi
			ausgabe "Automatische Updates durch STEAM: $YN" gruen

			echo "PARAMS='-game cstrike +port $PORT +map $START_MAP +maxplayers $MAX_PLAYER -tickrate $TICKRATE -autoupdate $AUTOUPDATE'" >> $RR_FILE

	 		echo "`cat ../$RR_DIR/_end.sh`" >> $RR_FILE
	if [ "$?" != "0" ];then
		logger "Es sind Fehler aufgetreten." "ERROR"
		ausgabe "Es sind Fehler aufgetreten." rot
		exit
	fi
			
fi

