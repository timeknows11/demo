#!/bin/bash
TOMCAT_HOME=/Users/apple/Dev/apache-tomcat-8.5.20
lockfile=${TOMCAT_HOME}/myservice

# start 
start(){
        if [ -e $lockfile ] ;then
                echo "Service is already running....."
                return 5
        else
                touch $lockfile
                bash ${TOMCAT_HOME}/bin/startup.sh
                echo "Service start ..."
                return 0
        fi
}
#stop
stop(){
        if [ -e $lockfile ] ; then
                rm -f $lockfile
                ps -ef|grep tomcat | grep -v grep | awk -F ' ' '{print $2}' | xargs kill -9
                echo "Service is stoped "
                return 0
        else
                echo "Service is not run "
                return 5
        fi

}
#restart 
restart(){
        stop
        start
}
usage(){
        echo "Usage:{start|stop|restart|status}"
}
status(){
        if [ -e $lockfile ];then
                echo "Service is running .."
                return 0
        else
                echo "Service is stop "
                return 0
        fi
}
case $1 in
start)
        start
        ;;
stop)
        stop
        ;;
restart)
        restart
        ;;
status)
        status
        ;;
*)
        usage
        exit 7
        ;;
esac
