#!/bin/bash

CPU_THRESHOLD=50
RAM_THRESHOLD=80
SWAP_THRESHOLD=20

LOG_DIR="/opt/monitoreng"
mkdir -p "$LOG_DIR"

VALUES_FILE="$LOG_DIR/values.txt"
touch "$VALUES_FILE"

MAX_MIN_VALUES_FILE="$LOG_DIR/max-min-values.txt"
touch "$MAX_MIN_VALUES_FILE"

MAX_CPU_USAGE=0
MAX_RAM_USAGE=0
MAX_SWAP_USAGE=0

MIN_CPU_USAGE=-1
MIN_RAM_USAGE=-1
MIN_SWAP_USAGE=-1

while true; do
    DATE=$(date '+%Y-%m-%d_%H-%M-%S')

    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')
    RAM_USAGE=$(free | awk '/Mem/ {print int($3/$2 * 100)}')
    SWAP_TOTAL=$(free -m | awk '/Swap/ {print $2}')
    SWAP_USED=$(free -m | awk '/Swap/ {print $3}')
    
    if [ "$SWAP_TOTAL" -eq 0 ]; then
        SWAP_USAGE=0
    else
        SWAP_USAGE=$(awk -v used="$SWAP_USED" -v total="$SWAP_TOTAL" 'BEGIN {printf "%d\n", (used/total)*100}')
    fi

    if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ] || [ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ] || [ "$SWAP_USAGE" -gt "$SWAP_THRESHOLD" ]; then
        LOG_FILE="$LOG_DIR/$DATE.log"
        echo "Date: $DATE" >> "$LOG_FILE"

        if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
            echo "CPU Usage is greater than $CPU_THRESHOLD%: $CPU_USAGE%" >> "$LOG_FILE"
        fi

        if [ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ]; then
            echo "RAM Usage is greater than $RAM_THRESHOLD%: $RAM_USAGE%" >> "$LOG_FILE"
        fi

        if [ "$SWAP_USAGE" -gt "$SWAP_THRESHOLD" ]; then
            echo "Swap Usage is greater than $SWAP_THRESHOLD%: $SWAP_USAGE%" >> "$LOG_FILE"
        fi
    fi

    echo "Date: $DATE" >> "$VALUES_FILE"
    echo "CPU Usage: $CPU_USAGE%" >> "$VALUES_FILE"
    echo "RAM Usage: $RAM_USAGE%" >> "$VALUES_FILE"
    echo "Swap Usage: $SWAP_USAGE%" >> "$VALUES_FILE"
    echo "---" >> "$VALUES_FILE"

    MAX_CPU_USAGE=$(( CPU_USAGE > MAX_CPU_USAGE ? CPU_USAGE : MAX_CPU_USAGE ))
    MAX_RAM_USAGE=$(( RAM_USAGE > MAX_RAM_USAGE ? RAM_USAGE : MAX_RAM_USAGE ))
    MAX_SWAP_USAGE=$(( SWAP_USAGE > MAX_SWAP_USAGE ? SWAP_USAGE : MAX_SWAP_USAGE ))

    if [ "$MIN_CPU_USAGE" -eq -1 ] || [ "$CPU_USAGE" -lt "$MIN_CPU_USAGE" ]; then
        MIN_CPU_USAGE=$CPU_USAGE
    fi

    if [ "$MIN_RAM_USAGE" -eq -1 ] || [ "$RAM_USAGE" -lt "$MIN_RAM_USAGE" ]; then
        MIN_RAM_USAGE=$RAM_USAGE
    fi

    if [ "$MIN_SWAP_USAGE" -eq -1 ] || [ "$SWAP_USAGE" -lt "$MIN_SWAP_USAGE" ]; then
        MIN_SWAP_USAGE=$SWAP_USAGE
    fi

    echo "Max-CPU-Value: $MAX_CPU_USAGE%" > "$MAX_MIN_VALUES_FILE"
    echo "Min-CPU-Value: $MIN_CPU_USAGE%" >> "$MAX_MIN_VALUES_FILE"
    echo "Max-RAM-Value: $MAX_RAM_USAGE%" >> "$MAX_MIN_VALUES_FILE"
    echo "Min-RAM-Value: $MIN_RAM_USAGE%" >> "$MAX_MIN_VALUES_FILE"
    echo "Max-Swap-Value: $MAX_SWAP_USAGE%" >> "$MAX_MIN_VALUES_FILE"
    echo "Min-Swap-Value: $MIN_SWAP_USAGE%" >> "$MAX_MIN_VALUES_FILE"

    sleep 5
done
