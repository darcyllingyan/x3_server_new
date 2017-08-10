#!/bin/sh

# ----------------------------------------------------------
# Script to start a X3 server
#
# Created by Xu Xiao, July 14 2017
# ----------------------------------------------------------

# sub function
usage(){
    echo "usage: "
    echo "   ./x3_server start xxu  :"
    echo "        start a x3 server with server name xxu, server name is mandatory"
    echo "   ./x3_server stop       :" 
    echo "        stop a x3 server"
    echo "   ./x3_server stop all   :"
    echo "        kill all the Erlang VM process belongs to the user"
}


# main function

# input parameter check
if [ $# -gt 2 ]  || [ $# -eq 0 ]
then
    usage
    exit 1
fi


case "$1" in
    "start")
        if [ "$2" ]
        then
           if [ $# -gt 2 ]
           then
               usage
           else
               sleep 1s
               # erl -sname x2 -remsh x1@xxu-ProLiant-DL380-G7
               erl -sname $2 -s x3_server -detached
               sleep 0.5s
               cat ./tmp.log
           fi
        else
            usage
        fi
        ;;
    "stop")
        if [ $# -eq 1 ]
        then
            erl -noshell -s command stop_server &
            #ps -efww | grep -w 'beam.smp' | grep -v grep | cut -c 9-15 | xargs kill -9
        else
            if [ "$2" = all ]
            then
                if [ `whoami` = "root" ];then  
                    echo "Reject! root account is not allow to run this script"  
                else  
                    echo "Kill all erlang vm process under current user!"
                    ps -efww | grep -w 'beam.smp' | grep -v grep | grep `whoami` | cut -c 9-15 | xargs kill -9
                fi  
            else
               usage
            fi
        fi
        ;;
    #"restart")
    #    erl -noshell -s command stop_server &
    #    #ps -efww | grep -w 'beam.smp' | grep -v grep | cut -c 9-15 | xargs kill -9
    #    if [ $# -eq 1 ]
    #    then
    #        sleep 2s
    #        #cd ../src && erlc *.erl && cd -
    #        erl -noshell -s x3_server start &
    #    else
    #        if [ "$2" = debug ]
    #        then
    #            sleep 2s
    #            #cd ../src && erlc *.erl && cd -
    #            erl -s x3_server start
    #        else
    #            usage
    #        fi
    #    fi
    #    ;;
    *)
        usage
        exit 1
        ;;
esac


