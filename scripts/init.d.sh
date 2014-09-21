#!/bin/bash

### BEGIN INIT INFO
# Provides:          gameserver
# Required-Start:    $remote_fs
# Required-Stop:     $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: game server
# Description:       Starts a game server
### END INIT INFO

NAME="gameserver"
USER="steam"
SCREENREF="gameserver"
BINARYPATH="/opt/server/scripts"
BINARYNAME="start.sh"
PIDFILE="server.pid"

cd "$BINARYPATH"

running() {
    if [ -f $PIDFILE ]; then
      ps -p `cat $PIDFILE`
      if [ $? = 0 ]; then
          return 0
      else
          return 1
      fi
    else
      return 1
    fi
}

start() {
    if ! running; then
        echo -n "Starting the $NAME server... "
        nohup $BINARYPATH/$BINARYNAME > /opt/server/server.log 2>&1 & echo $! > $PIDFILE
        sleep 3
        if [ -s $PIDFILE ]; then
            NEXT_WAIT_TIME=0
            until netstat -l | grep ":$PORT " || [ $NEXT_WAIT_TIME -eq 10 ]; do
              sleep $(( NEXT_WAIT_TIME++ ))
            done
            netstat -l | grep ":$PORT " > /dev/null
            if [ $? -ne 0 ]; then
              echo "Failed, port closed"
              cat $PIDFILE | xargs kill > /dev/null
              rm $PIDFILE
            else
              echo "Done"
            fi
        else
            echo "Failed, no PID"
            rm $PIDFILE
        fi
    else
        echo "The $NAME server is already started."
    fi
}

stop() {
    if running; then
        echo -n "Stopping the $NAME server... "
        kill `cat $PIDFILE`
        while running; do
            sleep 1
        done
        rm $PIDFILE
        echo "Done"
    else
        echo "The $NAME server is already stopped."
    fi
}

case "$1" in
    start)
        start
    ;;
    stop)
        stop
    ;;
    restart)
	stop
        start
    ;;
    status)
        if running; then
            echo "The $NAME server is started."
        else
            echo "The $NAME server is stopped."
        fi
    ;;
    *)
        echo "Usage: $0 (start|stop|restart|status)"
        exit 1
esac
exit 0
