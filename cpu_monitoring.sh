#!/bin/bash
cpucnt=`grep -c ^processor /proc/cpuinfo`
cpuuse=$(cat /proc/loadavg | awk '{print $3}'|cut -f 1 -d ".")
NOW=$(date +"%Y-%b-%d")
LOG="/bisorbit/dev/scripts/web1/cpustat_$NOW.out"
DATE="$(date +'%Y-%m-%d-%T')"
top -b -n 1 > /bisorbit/dev/script/web1/top-output.txt
echo "########### $DATE ###########" >> $LOG
#echo " " >> $LOG
echo "+------------------------------------------------------------------+" >> $LOG
echo "+*******************************************************************+" >> $LOG
echo "+------------------------------------------------------------------+" >> $LOG
echo " " >> $LOG
echo "Output of the top command " >> $LOG
echo "+----------------------------------------------------------------+" >> $LOG
head -n 30 /bisorbit/dev/scripts/web1/top-output.txt >> $LOG
echo " " >> $LOG
echo " Only bisorbit user process " >> $LOG
echo "============================" >> $LOG
grep -i bisorbit /bisorbit/dev/scripts/web1/top-output.txt >> $LOG
echo " " >> $LOG
echo "+------------------------------------------------------------------+" >> $LOG
echo "  " >> $LOG
echo "No of CPUs on server: $cpucnt" >> $LOG
echo "+------------------------------------------------------------------+" >> $LOG
echo " ">> $LOG
echo "CPU current usage is: $cpuuse%" >> $LOG
echo "" >> $LOG
echo "+------------------------------------------------------------------+" >> $LOG
echo " ">> $LOG
echo " ">> $LOG
echo "Top Processes which consuming high CPU using the ps command" >> $LOG
echo "+------------------------------------------------------------------+" >> $LOG
echo " ">> $LOG
echo "$(ps -eo pcpu,pid,user,args | sort -k 1 -r |grep -i bisorbit| head -10)" >> $LOG
echo " ">> $LOG
echo " Memory details " >> $LOG
echo "+------------------------------------------------------------------+" >> $LOG
free -g >> $LOG
echo " " >> $LOG
echo  "################   END   ################## " >> $LOG
echo " " >> $LOG