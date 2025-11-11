bisorbit@bisorbitwebqa01:~$ cat /bisorbit/software/scripts/tomcat_verify_start.sh
#!/bin/sh
#
# Verify and Start script for Tomcat

LOG="/tmp/tomcat_verify_start.log"
TO="t-9meera@uchicago.edu,barrettd@uchicago.edu,abellamy@hcg.com,rraupach@hcg.com,cgorny@hcg.com"
HOSTNAME=`hostname`
TOM_HOME=/u01/uat/orbweb/apache-tomcat-9.0.65
DATE="$(date +'%Y-%m-%d-%T')"
#/admin/sudo/become_bisorbit
TOM_CHECK()
{
tomcat_pid() {
   echo `ps -efa| grep apache-tomcat | grep java | egrep -v grep | awk '{print $2}'`
}
pid=$(tomcat_pid)
    if [ -n "$pid" ]
    then
        echo "TOMCAT is running with (processId: $pid)" >>$LOG
                else
        echo "TOMCAT not started.Proceeding to start now" >>$LOG
                sh $TOM_HOME/bin/startup.sh >>$LOG
                sleep 10s
aftertomstart_pid() {
   echo `ps -efa| grep apache-tomcat | grep java | egrep -v grep | awk '{print $2}'`
}
pid=$(aftertomstart_pid)
 if [ -n "$pid" ]
    then
        echo "TOMCAT is running with (processId: $pid)" >>$LOG &
                else
        echo "TOMCAT not started on $HOSTNAME plese check the logs" >>$LOG
                mail -s "TOMCAT not started on $HOSTNAME please check the logfile $TOM_HOME/logs and action" $TO
                fi
fi
}
echo " ###################### $DATE ######################### "  >> $LOG
echo " "  >> $LOG
TOM_CHECK >> $LOG
