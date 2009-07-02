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
#  File.........: Packages/Mods/install.sh                   #
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

clear
source _functions.sh

ausgabe "Willkommen bei der Mod-Installation" blau
ausgabe "Fuer welches Spiel soll eine Modifikation installiert werden ?" blau
ausgabe "1) Counsterstrike 1.6" blau
ausgabe "2) Counterstrike: Source" blau
ausgabe "0/Keine Angabe) Zurueck" rot
read GAME

	if [ "$GAME" == 0 ] || [ "$GAME" == "" ];then
		logger "No option has been given, restart the script." "WARN"
		sh interface.sh
	fi
	
	if [ "$GAME" == 1 ];then
		ausgabe "-Counterstrike 1.6 gewaehlt." gruen
		echo ""
		ausgabe "Welche MOD soll installiert werden ?" blau
		ausgabe "1) MetaMOD" blau
		ausgabe "2) AMXX" blau	
		ausgabe "0/Keine Angabe) Zurueck" rot
		read MOD

			if [ "$MOD" == 0 ] || [ "$MOD" == "" ];then
				logger "No modification has been given, restart the script." "WARN"
				sh interface.sh
			fi

			if [ "$MOD" == 1 ];then
				ausgabe "-MetaMOD gewaehlt" gruen
				MODI="metamod"
			elif [ "$MOD" == 2 ];then
                                ausgabe "-AMXX gewaehlt" gruen
				MODI="amxx"
			fi

                ausgabe "Fuer welchen Port soll die MOD installiert werden ?" blau
                read PORT

                        if [ "$PORT" == 0 ] || [ "$PORT" == "" ];then
                                logger "No port has been given, restart the script." "WARN"
                                sh interface.sh
                        fi

                sh $MOD_DIR/CS/$MODI.sh install $PORT
	
	elif [ "$GAME" == 2 ];then
                ausgabe "-Counterstrike: Source gewaehlt." gruen
                echo ""
                ausgabe "Welche MOD soll installiert werden ?" blau
                ausgabe "1) MetaMOD: Source" blau
                ausgabe "2) Mani Admin Plugin" blau
                ausgabe "0/Keine Angabe) Zurueck" rot
                read MOD

                        if [ "$MOD" == 0 ] || [ "$MOD" == "" ];then
                                logger "No modification has been given, restart the script." "WARN"
                                sh interface.sh
                        fi

                        if [ "$MOD" == 1 ];then
                                ausgabe "-MetaMOD:Source gewaehlt" gruen
                        	MODI="sourcemm"
			elif [ "$MOD" == 2 ];then
                                ausgabe "-ManiAdmin gewaehlt" gruen
                        	MODI="maniadmin"
			fi

		ausgabe "Fuer welchen Port soll die MOD installiert werden ?" blau
		read PORT
			
			if [ "$PORT" == 0 ] || [ "$PORT" == "" ];then
				logger "No port has been given, restart the script." "WARN"
				sh interface.sh
			fi

		sh $MOD_DIR/CSS/$MODI.sh install $PORT 
	
	fi

