#!/bin/bash

# match any string that starts with "event" and its name does not start with Log
EVT=`grep -orP 'event\s+(?!Log)(\w+)\s*' contracts/*`

if [ -z "$EVT" ]; then
    echo "Event definitions all start with 'Log'"
else
    echo "Invalid event definitions found:"
    echo "$EVT"
    exit 1
fi

