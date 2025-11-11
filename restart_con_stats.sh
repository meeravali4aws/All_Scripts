bisorbit@bisorbitdockerdev01:~$ cat /bisorbit/dev/scripts/Con_stats/restart_con_stats.sh
#!/bin/bash
if ! pgrep -f "docker_container_stats.sh" > /dev/null; then
    echo "$(date): Restarting docker_container_stats.sh" >> /tmp/docker_script_monitor.log
    nohup sh  /bisorbit/dev/scripts/Con_stats/docker_container_stats.sh >> /tmp/docker_stats.log 2>&1 &
fi
