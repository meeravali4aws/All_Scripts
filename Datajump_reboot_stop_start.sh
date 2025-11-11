#!/bin/bash
#set -x
DATE="$(date +'%Y-%m-%d-%T')"
HOSTNAME=`hostname`
SUBJECT="ALERT: Datajump services on hostname $HOSTNAME"
TO="skovur@uchicago.edu sandeep.bomma@orbitanalytics.com arun.velicheti@orbitanalytics.com meeravali.shaik@orbitanalytics.com deepak.ubale@orbitanalytics.com rajinikanth.nukula@orbitanalytics.com"
MAILLOG=/tmp/docker_status_$DATE.out

# Navigate to the directory containing the docker-compose.yml file
cd /u01/datajump > /tmp/docker_start_stop_$DATE.out
echo "############################### $DATE #############################################" >> /tmp/docker_start_stop_$DATE.out
docker compose down >> /tmp/docker_start_stop_$DATE.out
sleep 1m
echo "******************************************************************************* " >> /tmp/docker_start_stop_$DATE.out
docker compose up -d >> /tmp/docker_start_stop_$DATE.out
sleep 2m
echo "############################### $DATE #############################################" >> /tmp/docker_status_$DATE.out
echo " " >> /tmp/docker_status_$DATE.out
docker ps  >> /tmp/docker_status_$DATE.out
echo " " >> /tmp/docker_status_$DATE.out
echo "******************************************************************************* " >> /tmp/docker_status_$DATE.out
docker image >> /tmp/docker_status_$DATE.out
echo " " >> /tmp/docker_status_$DATE.out
echo "###################################################################################################################" >> /tmp/docker_status_$DATE.out
  MAILLOG=$(cat /tmp/docker_status_$DATE.out)
if [ $? = 0 ]
then
       echo -e "$MAILLOG" | mail -s "$SUBJECT" "${TO}"
fi
else
    echo "Containers are already running." >> /tmp/docker_status_$DATE.out
fi



#!/bin/bash
#set -x
DATE="$(date +'%Y-%m-%d-%T')"
HOSTNAME=`hostname`
SUBJECT="ALERT: Datajump services on hostname $HOSTNAME"
TO="skovur@uchicago.edu sandeep.bomma@orbitanalytics.com arun.velicheti@orbitanalytics.com meeravali.shaik@orbitanalytics.com deepak.ubale@orbitanalytics.com rajinikanth.nukula@orbitanalytics.com"
MAILLOG=/tmp/docker_status_$DATE.out

# Navigate to the directory containing the docker-compose.yml file
cd /u01/datajump > /tmp/docker_start_stop_$DATE.out
echo "############################### $DATE #############################################" >> /tmp/docker_start_stop_$DATE.out
/admin/sudo/manage_docker compose down >> /tmp/docker_start_stop_$DATE.out
sleep 1m
echo "******************************************************************************* " >> /tmp/docker_start_stop_$DATE.out
/admin/sudo/manage_docker compose up -d >> /tmp/docker_start_stop_$DATE.out
sleep 2m
echo "############################### $DATE #############################################" >> /tmp/docker_status_$DATE.out
echo " " >> /tmp/docker_status_$DATE.out
/admin/sudo/manage_docker ps  >> /tmp/docker_status_$DATE.out
echo " " >> /tmp/docker_status_$DATE.out
echo "******************************************************************************* " >> /tmp/docker_status_$DATE.out
/admin/sudo/manage_docker image ls >> /tmp/docker_status_$DATE.out
echo " " >> /tmp/docker_status_$DATE.out
echo "###################################################################################################################" >> /tmp/docker_status_$DATE.out
  MAILLOG=$(cat /tmp/docker_status_$DATE.out)
if [ $? = 0 ]
then
       echo -e "$MAILLOG" | mail -s "$SUBJECT" "${TO}"
fi
else
    echo "Containers are already running." >> /tmp/docker_status_$DATE.out
fi