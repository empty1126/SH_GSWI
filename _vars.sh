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
#  File.........: _vars.sh  	                             #
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

STER_SRV=85.214.43.91/Files/
RR_DIR=Scripts/
PACKAGE_DIR=Files/
MOD_DIR=Packages/Mods/
DEBUGG=true
VERS=1.0
GAME_PATH=/home/gameserver/
ADMIN_EMAIL=Technik@Streamhousing.de
ADDON_DIR=Files/Addons/


TIME=`date +%H:%M:%S`;
DATE=`date +%D`
NOW=$(date +"%b-%d-%y")

LOG_DIR="/var/log/gswi/"
LOG_FILE="$LOG_DIR/$NOW.log"

