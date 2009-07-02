#!/bin/sh
NAME=28000
DESK="gameserver"
SCRIPT=hlds_run
DIR=/home/gameserver//28000
PARAMS='-game cstrike +port 28000 +map de_dust2 +maxplayers 12 -tickrate 100 -autoupdate 1'
DAEMON=$DIR/$SCRIPT

case "$1" in
start)
   echo "Starte $DESC: $NAME"
   cd $DIR
   screen -d -m -S $NAME $DAEMON $PARAMS > /dev/null
   ;;

stop)
   if [[ `screen -ls |grep $NAME` ]]
   then
       echo -n "Stoppe $DESC: $NAME"
       kill `screen -ls |grep $NAME |awk -F . '{print $1}'|awk '{print $1}'`
       echo " ... Server gestoppt."
   else
       echo "Konnte keinen laufenden Server mit PID -- $DESC -- nicht finden"
   fi
   ;;

restart)
   if [[ `screen -ls |grep $NAME` ]]
   then
       echo -n "Stoppe $DESC: $NAME"
       kill `screen -ls |grep $NAME |awk -F . '{print $1}'|awk '{print $1}'`
       echo " ... Server gestoppt ... Kommando Start wird ausgef.hrt"
   else
       echo "Konnte keinen laufenden Server mit PID -- $DESC -- nicht finden ... Kommando Start wird ausgef.hrt"
   fi

   echo -n "Starte $DESC: $NAME"
   cd $DIR
   screen -d -m -S $NAME $DAEMON $PARAMS > /dev/null
   echo " ... Server gestartet."
   ;;

*)
   echo "Usage: $0 Parameter eingeben {start|stop|restart}"
   exit 1
   ;;
esac

exit 0
