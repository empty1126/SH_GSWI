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
#  File.........: interface.sh                               #
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


GAME_PATH=/home/gameserver/
ADMIN_EMAIL=Technik@Streamhousing.de

source _functions.sh

logger "Starting script, with version: '$VERS' as user: '`whoami`'." "DEBUGG"

case "$1" in

	help)
		help
	;;
	*)
		clear
		ausgabe "Willkommen im Gameserver Interface von Streamhousing.de" blau
		ausgabe "Was moechten Sie machen ?" blau
		ausgabe "1) Gameserver installieren" blau
		ausgabe "2) Gameserver deinstallieren" blau
		ausgabe "3) Gameserver starten" blau
                ausgabe "4) Gameserver stoppen" blau
                ausgabe "5) Gameserver neustarten" blau
		echo ""
		ausgabe "6) Modinstallation" blau
		echo ""
		ausgabe "7) Logfiles saeubern" blau 
		echo ""
		ausgabe "8) Hilfe anzeigen" blau
		echo ""
		ausgabe "0/Keine Eingabe) Zurueck" rot
		read WHAT_TO_DO

			if [ "$WHAT_TO_DO" == "" ];then  
				logger "No option has been given, restart the script." "WARN"
				sh intdwad.sdh 2> "$LOG_DIR/logg_stderr"
				std_err
			elif [ "$WHAT_TO_DO" == 0 ];then 
				logger "No option has been given, restart the script." "WARN"
				sh interface.sh 2> "$LOG_DIR/logg_stderr"
				std_err
			elif [ "$WHAT_TO_DO" == "1" ];then
				clear 
				ausgabe "Sie wollen einen Gameserver installieren." gruen
				ausgabe "Bitte waehlen Sie aus welches Spiel installiert werden soll." blau
				ausgabe "1) Counterstrike 1.6" gruen
				ausgabe "2) Counterstrike: Source" gruen
		                ausgabe "0/Keine Eingabe) Zurueck" rot

				read GAME; 
					if [ "$GAME" == "" ];then 
						logger "No Game has been given, restart the script." "WARN"
						sh interface.sh 2> "$LOG_DIR/logg_stderr"
		                                std_err
					elif [ "$GAME" == "0" ];then 
						logger "No Game has been given, restart the script." "WARN" 
						sh interface.sh 2> "$LOG_DIR/logg_stderr"
		                                std_err
					elif [ "$GAME" == "1" ];then
						ausgabe "Sie haben Counterstrike 1.6 ausgewaehlt" gruen
						ausgabe "Port ? [default 27015]" blau
						read PORT 
						
							if [ "$PORT" == "" ]; then
								logger "No Port for install has been given, restart the script." "WARN"
 								PORT=27015
							elif [ "$PORT" -gt 65000 ];then
								logger "Der Port: '$PORT' liegt hoeher als 65000" "WARN"
								ausgabe "Port: '$PORT' ist zu hoch." rot
								exit
                                                        elif [ "$PORT" -lt 2500 ];then
								logger "Der Port: '$PORT' ist niedriger als 2500" "ERROR"
                                                                ausgabe "Port: '$PORT' ist zu niedrig." rot              
		                                    		exit
							fi

						 if [ -f "$GAME_PATH/$PORT/hlds_run" ];then
							logger "Der Port : '$PORT' wird bereits genutzt" "ERROR"
							ausgabe "Der gewaehlte Port: '$PORT' wird bereits genutzt." rot
 							exit
  						 fi
	
					 	 ausgabe "Port: '$PORT' wird benutzt." gruen
						 sh Packages/cs1_6.sh install $PORT $GAME_PATH 2> "$LOG_DIR/logg_stderr"
		                                 std_err
							if [ "$?" != "0" ];then
								logger "Es sind Fehler aufgetreten." "ERROR" 
								ausgabe "Es sind Fehler aufgetreten." rot
								exit
							fi 								
	
						 sh Packages/cs1_6.sh build $PORT $GAME_PATH 2> "$LOG_DIR/logg_stderr"
		                                 std_err


                                                        if [ "$?" != "0" ];then
                                                                logger "Es sind Fehler aufgetreten." "ERROR"
							        ausgabe "Es sind Fehler aufgetreten." rot
				                                exit
				                        fi
						 ausgabe "Die installation wurde erfolgreich abgeschlossen" gruen
						 sleep 2
						 sh interface.sh 2> "$LOG_DIR/logg_stderr"
		                                 std_err
 

					elif [ "$GAME" == 2 ];then
						ausgabe "CS:S ist noch nicht implementiert." "rot"
						logger "CS:S is not implemented, yet, exiting..." "SYSTEM_ERROR"
					fi
		
			elif [ "$WHAT_TO_DO" == 2 ];then
				clear
                                ausgabe "Sie wollen einen Gameserver deinstallieren." gruen
                                ausgabe "Bitte waehlen Sie aus welches Spiel deinstalliert werden soll." blau
                                ausgabe "1) Counterstrike 1.6" gruen
                                ausgabe "2) Counterstrike: Source" gruen
                                ausgabe "0/Keine Eingabe) Zurueck" rot

				read GAME
			
					if [ "$GAME" == "" ];then
						logger "No Game has been given" "WARN"
						sh interface.sh 2> "$LOG_DIR/logg_stderr"
		                                std_err
					elif [ "$GAME" == 1 ];then
						ausgabe "Gameserver-Port, welcher deinstalliert werden soll ?" blau
						read PORT

							if [ "$PORT" == "" ];then 
                                                                logger "Es wurde kein Port angegeben." "WARN"  
								ausgabe "Kein Port angegeben." rot
								sh interface.sh 2> "$LOG_DIR/logg_stderr"
					                        std_err
 							else
								ausgabe "Sie haben '$PORT' gewaehlt." gruen
								if [ -f "$GAME_PATH/$PORT/hlds_run" ];then
									sh Packages/cs1_6.sh deinstall $PORT $GAME_PATH 2> "$LOG_DIR/logg_stderr"
						                        std_err
 								else
									logger "Der Gameserver mit dem Port '$PORT' existiert nicht." "WARN"
									ausgabe "Der Gameserver unter Port: '$PORT' existiert nicht." rot
									sh interface.sh 2> "$LOG_DIR/logg_stderr"
						                        std_err
								fi
							fi			
					elif [ "$GAME" == 2 ];then
						ausgabe "CS:S deinstallation wurde nocht nich implementiert." rot
						logger "CS:S deinstallation is not implemented, yet, exiting..." "SYSTEM_ERROR"
					fi

			elif [ "$WHAT_TO_DO" == 3 ];then
				clear
				ausgabe "Sie moechten einen Gameserver starten" blau
				ausgabe "Port ?" blau
				read PORT
					if [ "$PORT" == "" ];then
						logger "Es wurde kein Port angegeben, starte das Script neu." "WARN"
						sh interface.sh 2> "$LOG_DIR/logg_stderr"
		                                std_err
					else
						ausgabe "Welches Spiel laeuft unter Port: '$PORT' ?" blau
						ausgabe "1) Counterstrike 1.6" gruen
						ausgabe "2) Counsterstrike: Source" gruen
						ausgabe "0/Keine Eingabe) Zurueck" rot
						read EXCUTABLE
							if [ "$EXCUTABLE" == "" ];then
								logger "No excutable has been given, restart the script." "WARN"
								sh interface.sh 2> "$LOG_DIR/logg_stderr"
				                                std_err
							elif [ "$EXCUTABLE" == 1 ];then
								EXCUT=hlds_run
								sh Packages/cs1_6.sh start $PORT $GAME_PATH 2> "$LOG_DIR/logg_stderr"
				                                std_err
							elif [ "$EXCUTABLE" == 2 ];then
								EXCUT=srcds_run
								ausgabe "CS:S start wurde noch nicht implementiert !" rot
								logger "CS:S start hasnt be implemnted yet, exiting..." "SYSTEM_ERROR"
							else
								logger "No Gameserver exists under port: '$PORT', sleep 2, and restart the script." "WARN"
								ausgabe "Es konnte kein Gameserver unter Port: '$PORT' gefunden werden." rot
								sleep 2
								sh interface.sh 2> "$LOG_DIR/logg_stderr"
				                                std_err
							fi
					fi		
			
			elif [ "$WHAT_TO_DO" == 4 ];then
				clear
				ausgabe "Sie moechten einen Gameserver stoppen" blau
				ausgabe "Port ?" blau
				read PORT
					if [ "$PORT" == "" ];then
						logger "No port has been given" "WARN"
						sh interface.sh 2> "$LOG_DIR/logg_stderr"
		                                std_err
					else
						ausgabe "Welches Spiel laueft unter Port: '$PORT' ?" blau
						ausgabe "1) Counterstrike 1.6" gruen
						ausgabe "2) Counsterstrike: Source" gruen
						ausgabe "0/Keine Eingabe) Zurueck" rot
						read EXCUTABLE
					        if [ "$EXCUTABLE" == "" ];then
							logger "No excutable has been given" "WARN"
						        sh interface.sh 2> "$LOG_DIR/logg_stderr"
			                                std_err
						elif [ "$EXCUTABLE" == 1 ];then
						        EXCUT=hlds_run
						        sh Packages/cs1_6.sh stop $PORT $GAME_PATH 2> "$LOG_DIR/logg_stderr"
			                                std_err
 						elif [ "$EXCUTABLE" == 2 ];then
							EXCUT=srcds_run
							ausgabe "CS:S Stop is not implemented yet, exiting.." rot
							exit
						else 
							logger "No Gameserver founded under port: '$PORT', sleep 2, and restart the script." "WARN"
							ausgabe "Es konnte kein Gameserver unter Port: '$PORT' gefunden werden." rot
							sleep 2
							sh interface.sh 2> "$LOG_DIR/logg_stderr"
			                                std_err
						fi
					fi
                        elif [ "$WHAT_TO_DO" == 5 ];then
                                clear 
                                ausgabe "Sie moechten einen Gameserver neustarten" blau
                                ausgabe "Port ?" blau
                                read PORT
                                        if [ "$PORT" == "" ];then
                                                logger "ES wurde kein Port angegeben." "WARN"
                                                sh interface.sh 2> "$LOG_DIR/logg_stderr"
		                                std_err
                                        else
                                                ausgabe "Welches Spiel laueft unter Port: '$PORT' ?" blau
                                                ausgabe "1) Counterstrike 1.6" gruen
                                                ausgabe "2) Counsterstrike: Source" gruen
                                                ausgabe "0/Keine Eingabe) Zurueck" rot
                                                read EXCUTABLE
                                                if [ "$EXCUTABLE" == "" ];then
							logger "No excutable has been given, restart the script." "WARN"
                                                        sh interface.sh 2> "$LOG_DIR/logg_stderr"
			                                std_err
                                                elif [ "$EXCUTABLE" == 1 ];then
                                                        EXCUT=hlds_run
                                                        sh Packages/cs1_6.sh restart $PORT $GAME_PATH 2> "$LOG_DIR/logg_stderr"
			                                std_err
	                                        elif [ "$EXCUTABLE" == 2 ];then
                                                        EXCUT=srcds_run
							logger "Counterstrike source restart ist noch nicht implementiert, abbruch..." "ERROR"
                                                        ausgabe "CS:S Restart is not implemented yet, exiting.." rot
                                                        exit
                                                else
							logger "Es konnte kein Gamserver unter diesem Port '$PORT' gefunden werden." "WARN"
                                                        ausgabe "Es konnte kein Gameserver unter Port: '$PORT' gefunden werden." rot
                                                        sleep 2
                                                        sh interface.sh 2> "$LOG_DIR/logg_stderr"
			                                std_err
                                                 fi
                                        fi
                        elif [ "$WHAT_TO_DO" == 6 ];then
				if [ -f "Packages/Mods/install.sh" ];then
					sh Packages/Mods/install.sh 2> "$LOG_DIR/logg_stderr"
	                                std_err
				else
					logger "Couldn't open Packages/Mods/install.sh" "SYSTEM_ERROR"
				fi 
			elif [ "$WHAT_TO_DO" == 7 ];then
				ausgabe "Sollen wirklich alle Logfiles geloescht werden? [J/n]" rot
				read REALLY
					if [ "$REALLY" == "" ];then
						logger "No options, restart the script." "WARN"
						sleep 2
						sh interface.sh 2> "$LOG_DIR/logg_stderr"
		                                std_err
					elif [ "$REALLY" == "n" ] || [ "$REALLY" == "N" ];then
						sleep 2
						sh interface.sh 2> "$LOG_DIR/logg_stderr"
		                                std_err
 					elif [ "$REALLY" == "J" ] || [ "$REALLY" == "j" ];then
						logger "" "LOG_CLEAR"
						sleep 2
						ausgabe "Log files wurden geloescht".
						logger "Logfiles wurden geloescht" "WARN"
						sh interface.sh 2> "$LOG_DIR/logg_stderr"
		                                std_err
					fi
			elif [ "$WHAT_TO_DO" == 8 ]; then
				help;
			fi
		
	;;
esac

