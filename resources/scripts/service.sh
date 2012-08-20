#!/bin/bash
#
# Services that I need on OSX that I don't necessarily want at startup.
# Also, I prefer `service x start` over any launchd syntax
#

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
        ;;
    redis           )
        RUNCMD="redis-server /usr/local/etc/redis.conf"
        ;;
    elasticsearch   )
        RUNCMD="elasticsearch -f -D es.config=/usr/local/Cellar/elasticsearch/0.19.8/config/elasticsearch.yml"
        ;;
    mysql           )
        RUNCMD="mysql.server start"
        ;;
    memcached       )
        RUNCMD="/usr/local/bin/memcached"
        ;;
    rabbitmq        )
        RUNCMD="rabbitmq-server"
        ;;
    *               )
        echo "$0: Unknown service name: ${SERVICE}"
        exit 1
        ;;
esac

StartService () {
    echo "Stopping ${SERVICE}..."
    `$RUNCMD`
}

StopService () {
    echo "Stopping ${SERVICE}..."
}

RestartService () {
    echo "Restarting ${SERVICE}..."
}

RunService () {
    case $ACTION in
      start  ) StartService   ;;
      stop   ) StopService    ;;
      restart) RestartService ;;
      *      )
        echo "$0: Unknown action: ${ACTION}"
        exit 1
        ;;
    esac
}

RunService
