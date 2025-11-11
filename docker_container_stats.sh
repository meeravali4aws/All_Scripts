bisorbit@bisorbitdockerdev01:~$ cat /bisorbit/dev/scripts/Con_stats/docker_container_stats.sh
#!/bin/bash

# Directory for logs
LOG_DIR="/bisorbit/dev/scripts/Con_stats/docker_stats_logs"
mkdir -p "$LOG_DIR"

while true; do
    # Get timestamp
     TIMESTAMP="$(date +'%Y-%m-%d-%T')"
    # Log file with current date
    LOG_FILE="$LOG_DIR/docker_stats_$(date +"%Y-%m-%d").log"

    # Append docker stats output to log file
        echo " " >> "$LOG_FILE"
    echo "############# $TIMESTAMP #############" >> "$LOG_FILE"
        #    docker stats --no-stream >> "$LOG_FILE"
     /admin/sudo/manage_docker stats --no-stream >> "$LOG_FILE"
    # Wait for 1 second before the next execution
    sleep 1
done
