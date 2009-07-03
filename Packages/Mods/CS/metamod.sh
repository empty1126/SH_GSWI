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
#  File.........: Packages/Mods/CS/metamod.sh                #
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

source _functions.sh || (logger "Couldn't include _functions.sh !" "SYSTEM_ERROR")

WHAT=$1
PORT=$2

if [ -f "$GAME_PATH/$PORT/hlds_run" ];then
	if [ -f "$ADDON_DIR/metamod.tar" ];then
		logger "Starting installation of MetaMod Cs1.6 for Port: '$PORT'" "INFO" "START"
		cp "$ADDON_DIR/metamod.tar" "$GAME_PATH/$PORT/metamod.tar" 
		cd "$GAME_PATH/$PORT/"
		tar -xvf "metamod.tar" &>/dev/null
		rm metamod.tar
			if [ "$?" != "0" ];then
				ausgabe "Es sind Fehler aufgetreten." rot
				exit
			fi

			ausgabe "MetaMod wurde erfolgreich installiert." gruen
			logger "Installation of MetaMod Cs1.6 for Port: '$PORT' completed" "INFO" "END"

	else
		ausgabe "Installationsdatei: 'metamod.tar' in: '$ADDON_DIR/metamod.tar' fehlt." rot
		logger "Installationfile: 'metamod.tar' in '$ADDON_DIR' does not exist." "SYSTEM_ERROR"
	fi

else
	ausgabe "Gameserver mit Port: '$PORT' existiert nicht." rot
	logger "Gameserver with Port: '$PORT' does not exist." "SYSTEM_ERROR"
	
fi
