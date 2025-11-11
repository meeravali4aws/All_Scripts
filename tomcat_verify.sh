bisorbit@bisorbitwebqa01:~$ cat /bisorbit/software/scripts/tomcat_verify.sh
#!/bin/sh
#
# script to validate Tomcat services
#
#/admin/sudo/become_bisorbit
LOG="/tmp/tomcat_verify.log"
TO="t-9arun@uchicago.edu"
HOSTNAME=`hostname`
TOMHOME=/u01/uat/orbweb/apache-tomcat-9.0.65
DATE="$(date +'%Y-%m-%d-%T')"
TOM_VERIFY()
{
tomcat_pid() {
   echo `ps -efa| grep apache-tomcat | grep java | egrep -v grep | awk '{print $2}'`
}
pid=$(tomcat_pid)
    if [ -n "$pid" ]
    then
        echo "TOMCAT is running with (processId: $pid)"
                else
        echo "TOMCAT not started please check the logfile $TOMHOME/logs and take necessary action "
        mail -s "TOMCAT not started on $HOSTNAME please check the logfile $TOMHOME/logs and action" $TO
        fi
}
echo " ###################### $DATE ######################### "  >> $LOG
echo " " >> $LOG
TOM_VERIFY >>$LOG
