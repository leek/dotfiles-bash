#!/bin/bash
#
# Services that I need on OSX that I don't necessarily want at startup.
# Also, I prefer `service x start` over any launchd syntax
#

# set -x

# Colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
NORMAL=$(tput setaf 7)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Ensure root
if [ `whoami` != root ]; then
    echo -e "${BOLD}${RED}Error! You must run service as root!${RESET}"
fi

# Test for arguments
if [ -z $1 ]; then
    echo "Usage: $0 servicename [start|stop|restart]"
    exit 1
fi

SERVICE=$1
ACTION=$2

# Setup services
case $SERVICE in
    mongodb         )
        RUNCMD="mongod run --config /usr/local/etc/mongod.conf"
        PID="$(pidof mongod)"
        ;;
    redis           )
        RUNCMD="redis-server /usr/local/etc/redis.conf"
        PID="$(pidof redis-server)"
        ;;
    elasticsearch   )
        RUNCMD="elasticsearch -f -D es.config=/usr/local/Cellar/elasticsearch/0.19.8/config/elasticsearch.yml"
        PID="$(pidof elasticsearch)"
        ;;
    mysql           )
        RUNCMD="mysql.server start"
        PID="$(pidof mysql.server)"
        ;;
    memcached       )
        RUNCMD="/usr/local/bin/memcached"
        PID="$(pidof memcached)"
        ;;
    rabbitmq        )
        RUNCMD="rabbitmq-server"
        PID="$(pidof rabbitmq-server)"
        ;;
    *               )
        echo "$0: Unknown service name: ${SERVICE}"
        exit 1
        ;;
esac

StartService () {
    if [[ ! -z "$PID" && $(ps -p $PID) ]]; then
        echo "${SERVICE} is already running."
        exit 1
    else
        echo "Starting ${SERVICE}..."
        $RUNCMD && echo -e "${BOLD}${GREEN}Done.${RESET}"
    fi
}

StopService () {
    if [[ ! -z "$PID" && $(ps -p $PID) ]]; then
        echo "Stopping ${SERVICE}..."
        kill "$PID" && echo -e "${BOLD}${GREEN}Done.${RESET}"
    else
        echo "${SERVICE} is *not* running."
        exit 1
    fi
}

RestartService () {
    if [[ ! -z "$PID" && $(ps -p $PID) ]]; then
        StopService && StartService
    else
        StartService
    fi
}

ServiceStatus () {
    if [[ ! -z "$PID" && $(ps -p $PID) ]]; then
        echo "${SERVICE} is running with pid: ${PID}"
    else
        echo -e "${SERVICE} is ${BOLD}${YELLOW}not${RESET} running."
    fi
}

RunService () {
    case $ACTION in
        start  )
            StartService
            ;;
        stop   )
            StopService
            ;;
        restart)
            RestartService
            ;;
        status )
            ServiceStatus
            ;;
        *      )
            echo "$0: Unknown action: ${ACTION}"
            exit 1
            ;;
    esac
}

RunService
