#!/bin/sh
#
# File: prototpye.sed
#
# Note: none
#
# This finish script does the edits that we otherwise have to remember to do. 
#
# $1 = directory where the file lives
# $2 = the file to be edited
# $3 = sed script to execute
#
# --------------------------------------------------------------------------
# $Id: runsed.sh 4 2012-11-15 21:43:41Z svwebadmin $
# --------------------------------------------------------------------------#

DIRECTORY=$1
FILE=$2
SEDSCRIPT=$3
EDITS=scripts/sedscripts
#set -x

runsed()
{
    echo "editing ${DIRECTORY}/${FILE}: \c"
    if test "${DIRECTORY}/${FILE}" = "${SEDSCRIPT}"; then
        echo "not editing ${SEDSCRIPT}!"
    elif test -s ${DIRECTORY}/${FILE}; then
   #     sed -f ${EDITS}/${SEDSCRIPT} ${DIRECTORY}/${FILE} > /tmp/${FILE}
        sed -f ${SEDSCRIPT} ${DIRECTORY}/${FILE} > /tmp/${FILE}
        if test -s /tmp/${FILE}
        then
            cmp -s ${DIRECTORY}/${FILE} /tmp/${FILE} && echo "file not changed: ${FILE}";\
            cp /tmp/${FILE} ${DIRECTORY}/${FILE}; echo "done"
        else
            echo "Sed produced an empty file - check your ${SEDSCRIPT} sedscript."
        fi
    else
        echo "original file is empty."
    fi
}

runsed ${DIRECTORY} ${FILE} ${SEDSCRIPT}

rm -r /tmp/${FILE}

