#!/bin/bash

# Specify the server to monitor
SERVER="SERVERNAME"

# Define the performance counters to monitor
COUNTERS=('/proc/loadavg' '/proc/meminfo' '/proc/diskstats' '/proc/net/dev')

# Define the threshold values for each counter
THRESHOLDS=(
    ["/proc/loadavg"]="1.0"
    ["/proc/meminfo"]="1048576"
    ["/proc/diskstats"]="100"
    ["/proc/net/dev"]="10000000"
)

# Continuously monitor the performance counters and send an email if any counter exceeds its threshold
while true; do
    DATE=$(date +"%Y-%m-%d %H:%M:%S")
    OUTPUT=""
    for COUNTER in "${COUNTERS[@]}"; do
        case $COUNTER in
            "/proc/loadavg")
                VALUE=$(cut -d ' ' -f 1-3 /proc/loadavg)
                THRESHOLD=${THRESHOLDS["$COUNTER"]}
                if (( $(echo "$VALUE > $THRESHOLD" | bc -l) )); then
                    OUTPUT+="$COUNTER value of $VALUE exceeds threshold of $THRESHOLD.\n"
                fi
                ;;
            "/proc/meminfo")
                VALUE=$(awk '/MemAvailable/ { print int($2/1024) }' /proc/meminfo)
                THRESHOLD=${THRESHOLDS["$COUNTER"]}
                if (( $VALUE < $THRESHOLD )); then
                    OUTPUT+="$COUNTER value of $VALUE MB is below threshold of $THRESHOLD MB.\n"
                fi
                ;;
            "/proc/diskstats")
                VALUE=$(awk '{ if ($4 == "sda" && $6 == "read") print $6$4"="int($10/60) }' /proc/diskstats)
                THRESHOLD=${THRESHOLDS["$COUNTER"]}
                if (( $VALUE > $THRESHOLD )); then
                    OUTPUT+="$COUNTER value of $VALUE reads/sec exceeds threshold of $THRESHOLD.\n"
                fi
                VALUE=$(awk '{ if ($4 == "sda" && $6 == "write") print $6$4"="int($10/60) }' /proc/diskstats)
                if (( $VALUE > $THRESHOLD )); then
                    OUTPUT+="$COUNTER value of $VALUE writes/sec exceeds threshold of $THRESHOLD.\n"
                fi
                ;;
            "/proc/net/dev")
                VALUE=$(awk '/: / { if ($1 != "lo:") print $2+$10 }' /proc/net/dev)
                THRESHOLD=${THRESHOLDS["$COUNTER"]}
                if (( $VALUE > $THRESHOLD )); then
                    OUTPUT+="$COUNTER value of $VALUE B/s exceeds threshold of $THRESHOLD B/s.\n"
                fi
                ;;
        esac
    done
    if [[ -n "$OUTPUT" ]]; then
        SUBJECT="Server Performance Alert"
        BODY="The following performance counters on $SERVER have exceeded their thresholds as of $DATE:\n\n$OUTPUT"
        echo -e "$BODY" | mail -s "$SUBJECT" -r "monitor@example.com" "admin@example.com"
    fi
    sleep 60
done
