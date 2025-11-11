bisorbit@bisorbitwebqa01:~$ cat /bisorbit/software/scripts/stats/web1/ping.sh
#!/bin/bash

# Directory for logs
LOG_DIR="/bisorbit/software/scripts/stats/web1"
mkdir -p $LOG_DIR

# Server to ping
SERVER="bisorbitdbqa03.uchicago.edu"

# Infinite loop to ping every second
while true; do
  # Get the current timestamp and date
  CURRENT_DATE="$(date +'%Y-%m-%d %T')"
  DATE="$(date +'%Y-%m-%d')"

  # Define the log file for the current date
  LOG="$LOG_DIR/ping_$DATE.out"

  # Write a timestamped header to the log
  {
    echo " "
    echo "*******************************"
    echo "***** $CURRENT_DATE *****"
    echo "*******************************"
  } >> "$LOG"

  # Ping the server and append the output to the log
  ping -c 1 $SERVER >> "$LOG"

  # Append a footer to the log
  echo "**********************************************************" >> "$LOG"

  # Wait for 1 second before the next ping
  sleep 1
done
