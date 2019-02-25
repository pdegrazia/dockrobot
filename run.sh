#!/usr/bin/env bash

xhost +local:docker

ROBOT_OPTIONS=""
FILENAME=""
OUTPUTDIR="--outputdir /reports"


while getopts "i:e:v:" option; do
    case $option in
        i) INCLUDE_TAGS+=("$OPTARG") ;;
        e) EXCLUDE_TAGS+=("$OPTARG") ;;
        v) VARIABLES+=("$OPTARG") ;;
    esac
done


#getting the last argument to the script, should always be the filename
shift $((OPTIND-1))
FILENAME="$1"

#USEFUL OUTPUT FOR DEBUGGING
#echo ${INCLUDE_TAGS[@]}
#echo ${EXCLUDE_TAGS[@]}

if [ -n $INCLUDE_TAGS ];  #length greater than zero
    then
        for include_tag in "${INCLUDE_TAGS[@]}"; do
            ROBOT_OPTIONS+=" -i $include_tag"
    done
fi

if [ -n $EXCLUDE_TAGS ] #length greater than zero
    then
        for exclude_tag in "${EXCLUDE_TAGS[@]}"; do
            ROBOT_OPTIONS+=" -e $exclude_tag"
        done
fi

if [ -n $VARIABLES ] #length greater than zero
    then
        for variable in "${VARIABLES[@]}"; do
            ROBOT_OPTIONS+=" -v $variable"
        done
fi



#USEFUL OUTPUT FOR DEBUGGING
#echo $FILENAME
#echo $ROBOT_OPTIONS


docker run --shm-size=2gb \
           --net=host \
           -e DISPLAY \
           -v /tmp/.X11-unix \
           -v $(pwd)/tests:/tests/:Z \
           -v $(pwd)/reports/:/reports/:Z \
           -v $(pwd)/libraries:/libraries \
            selupgrade \
            robot --extension robot:txt $ROBOT_OPTIONS $OUTPUTDIR /tests/$FILENAME

