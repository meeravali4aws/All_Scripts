[orbit@encore-prod-01 script]$ cat blazdata_file.sh
#!/bin/bash
DATE=`date +"%Y-%m-%d %H:%M:%S"`
HOSTNAME=`hostname`
SUBJECT="ALERT:Blaze Files size on Encore PROD [$HOSTNAME(Time:$DATE)]"
# Define the directory path
#directory="/orbit_home/orbhome/test/services/blaze/data"
#directory="/u01/backup"
directory="/u01/orbit_home/services/blaze/data"
# Create a CSV file with the file sizes
csv_file="/u01/script/file_sizes.csv"

# Initialize counter
counter=1

# Function to print table header
print_header() {
    printf "%-15s %-70s %-20s\n" "Sl No"                        "Filename"                             "Fsize GB"
    printf "%-15s %-70s %-20s\n" "------" "--------------------------------------------------------" "------------"
}

# Function to print table row
print_row() {
    printf "%-15s %-70s %-20s\n" "$1" "$2" "$3"
}

# Print table header to CSV file
print_header > "$csv_file"

# Iterate over files in the directory and calculate sizes
for file in "$directory"/*; do
    filename=$(basename "$file")
    size_bytes=$(du -b "$file" | awk '{print $1}')
    size_gb=$(echo "scale=2; $size_bytes / (1024 * 1024 * 1024)" | bc)
    print_row "$counter" "$filename" "$size_gb" >> "$csv_file"
    ((counter++))
done

# Define email parameters
recipient="managedservices@orbitanalytics.com,rajiya.begum@orbitanalytics.com"
subject="File Sizes Report"
body="Please find the attached file sizes report."

# Read CSV file content and append to email body
body+="\n\n$(column -t -s ',' "$csv_file")"

# Send email with attached CSV file
echo -e "$body" | mail -s "$SUBJECT" "$recipient"
