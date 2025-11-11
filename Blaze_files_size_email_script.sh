#!/bin/bash

DATE=$(date +"%Y-%m-%d %H:%M:%S")
HOSTNAME=$(hostname)
SUBJECT="ALERT: Blaze Files Size on DH PROD [$HOSTNAME (Time: $DATE)]"

# Define the directories to check
directories=(
    "/orbit_home/orbhome/prod/services/blaze/data/tahweel_orbit_glsense_finance_cube__2424921_ylpx9"
    "/orbit_home/orbhome/prod/services/blaze/data/tahweel_orbit_glsense_uae_finance_c_2425616_bis85"
)

# Email recipient
recipient=("managedservices@orbitanalytics.com","rajiya.begum@orbitanalytics.com")
#recipient="meeravali.shaik@orbitanalytics.com"

# Temporary file to store the email body
EMAIL_BODY_FILE="/tmp/email_body.html"

# Create the email with headers
cat > "$EMAIL_BODY_FILE" <<EOF
To: $recipient
Subject: $SUBJECT
MIME-Version: 1.0
Content-Type: text/html; charset=UTF-8

<html>
<head>
    <title>File Sizes Report</title>
    <style>
        body { font-family: Arial, sans-serif; font-size: 14px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid black; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>File Sizes Report - $DATE</h2>
    <p>Please find below the file size details for each directory:</p>
EOF

# Iterate over each directory and create separate tables
for directory in "${directories[@]}"; do
    echo " " >> "$EMAIL_BODY_FILE"
    echo "<h3>Directory: $directory</h3>" >> "$EMAIL_BODY_FILE"
    echo "*************************************************************************************************************" >> "$EMAIL_BODY_FILE"


    if [ -d "$directory" ]; then
        cat >> "$EMAIL_BODY_FILE" <<EOF
    <table>
        <tr>
            <th>Sl No</th>
            <th>Filename</th>
            <th>Size (MB)</th>
        </tr>
EOF

        # Initialize counter
        counter=1

        for file in "$directory"/*; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                size_bytes=$(stat -c%s "$file")
                size_mb=$(echo "scale=2; $size_bytes / (1024 * 1024)" | bc)

                cat >> "$EMAIL_BODY_FILE" <<EOF
        <tr>
            <td>$counter</td>
            <td>$filename</td>
            <td>$size_mb</td>
        </tr>
EOF
                ((counter++))
            fi
        done

        echo "</table>" >> "$EMAIL_BODY_FILE"
    else
        echo "<p><strong>Warning:</strong> Directory <code>$directory</code> does not exist.</p>" >> "$EMAIL_BODY_FILE"
    fi
done

# Close the HTML structure
cat >> "$EMAIL_BODY_FILE" <<EOF
</body>
</html>
EOF

# Send email using `sendmail`
sendmail -t < "$EMAIL_BODY_FILE"

# Cleanup temporary file
rm -f "$EMAIL_BODY_FILE"

echo "Email sent to $recipient with file size details in separate tables."
