bisorbit@bisorbitwebqa01:~$ cat /bisorbit/software/scripts/stats/web1/check_urls.sh
#!/bin/bash

# List of URLs to check
URLS=(
  "https://orbitreportingqa.uchicago.edu/reporting"
  "http://bisorbitwebqa01.uchicago.edu:8080/reporting"
  "http://10.50.158.157:8080"
  # Add more URLs as needed
)

# Directory to store log files
LOG_DIR="/bisorbit/software/scripts/stats/web1"
mkdir -p $LOG_DIR

# Infinite loop to run the curl command every second
while true; do
  # Get the current date and timestamp
  DATE="$(date +'%Y-%m-%d')"
  CURRENT_DATE="$(date +'%Y-%m-%d %T')"

  # Define log file for the current day
  LOG="$LOG_DIR/check_urls_$DATE.out"

  # Log the current timestamp
  {
    echo "################################################"
    echo "############### $CURRENT_DATE ##########"
    echo "################################################"
  } >> $LOG

  # Loop through each URL in the list
  for URL in "${URLS[@]}"; do
    {
      echo "Checking URL: $URL"
      curl -vi $URL 2>&1
      echo "######################################################################*"
    } >> $LOG
  done

  # Wait for 1 second before running again
  sleep 1
done
