bisorbit@bisorbitwebqa01:~$ cat /bisorbit/software/scripts/UAT/DB_connection/web1/db_connection.sh
#!/bin/bash
#set -x
HOST=bisorbitdbqa03.uchicago.edu
export date_now="$(date +"%Y-%b-%d")"
PORT=4522
LOG_FILE=/bisorbit/software/scripts/UAT/DB_connection/web1/${date_now}.log


INTERVAL=1

check_connection() {
    # Try to connect using telnet
    (echo > /dev/tcp/$HOST/$PORT) 2>/dev/null

    # Check if the connection was successful
    if [ $? -ne 0 ]; then
        # If connection fails, log the failure with date and time
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Connection to $HOST on port $PORT failed" >> "$LOG_FILE"
    fi
}

# Infinite loop to check connection at intervals
while true; do
    check_connection
    sleep $INTERVAL
done
