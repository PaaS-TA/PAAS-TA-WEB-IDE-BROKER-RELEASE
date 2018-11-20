# links a job file (probably a config file) into a package
# Example usage:
# link_job_file_to_package config/redis.yml [config/redis.yml]
# link_job_file_to_package config/wp-config.php wp-config.php
echo "echo 19"
link_job_file_to_package() {
  echo "echo 19-1"
  source_job_file=$1
  target_package_file=${2:-$source_job_file}
  full_package_file=$WEBAPP_DIR/${target_package_file}

  link_job_file ${source_job_file} ${full_package_file}
}

# links a job file (probably a config file) somewhere
# Example usage:
# link_job_file config/bashrc /home/vcap/.bashrc
echo "echo 20"
link_job_file() {
  source_job_file=$1
  target_file=$2
  full_job_file=$JOB_DIR/${source_job_file}
  echo "echo 21"
  echo link_job_file ${full_job_file} ${target_file}
  if [[ ! -f ${full_job_file} ]]
  then
    echo "echo 22"
    echo "file to link ${full_job_file} does not exist"
  else
    echo "echo 23"
    # Create/recreate the symlink to current job file
    # If another process is using the file, it won't be
    # deleted, so don't attempt to create the symlink
    mkdir -p $(dirname ${target_file})
    ln -nfs ${full_job_file} ${target_file}
  fi
}

# If loaded within monit ctl scripts then pipe output
# If loaded from 'source ../utils.sh' then normal STDOUT
echo "echo 24"
redirect_output() {
  echo "echo 25"
  SCRIPT=$1
  mkdir -p /var/vcap/sys/log/monit
  exec 1>> /var/vcap/sys/log/monit/$SCRIPT.log
  exec 2>> /var/vcap/sys/log/monit/$SCRIPT.err.log
}

echo "echo 26"
pid_guard() {
  echo "echo 427"
  pidfile=$1
  name=$2
  echo "echo 27"
  if [ -f "$pidfile" ]; then
    pid=$(head -1 "$pidfile")
    echo "echo 28"
    if [ -n "$pid" ] && [ -e /proc/$pid ]; then
      echo "$name is already running, please stop it first"
      exit 1
    fi

    echo "Removing stale pidfile..."
    rm $pidfile
  fi
}
 echo "echo 29"
wait_pid() {
  pid=$1
  try_kill=$2
  timeout=${3:-0}
  force=${4:-0}
  countdown=$(( $timeout * 10 ))
 echo "echo 30"
  echo wait_pid $pid $try_kill $timeout $force $countdown
  if [ -e /proc/$pid ]; then
    if [ "$try_kill" = "1" ]; then
      echo "Killing $pidfile: $pid "
      kill $pid
      echo "echo 31"
    fi
    while [ -e /proc/$pid ]; do
      sleep 0.1
      echo "echo 32"
      [ "$countdown" != '0' -a $(( $countdown % 10 )) = '0' ] && echo -n .
      if [ $timeout -gt 0 ]; then
      echo "echo 33"
        if [ $countdown -eq 0 ]; then
          echo "echo 34"
          if [ "$force" = "1" ]; then
            echo -ne "\nKill timed out, using kill -9 on $pid... "
            kill -9 $pid
            sleep 0.5
          fi
          break
        else
          countdown=$(( $countdown - 1 ))
        fi
      fi
    done
    if [ -e /proc/$pid ]; then
      echo "Timed Out"
      echo "echo 35"
    else
      echo "Stopped"
    fi
  else
    echo "Process $pid is not running"
    echo "Attempting to kill pid anyway..."
    kill $pid
  fi
}

echo "echo 36"
wait_pidfile() {
  pidfile=$1
  try_kill=$2
  timeout=${3:-0}
  force=${4:-0}
  countdown=$(( $timeout * 10 ))

  if [ -f "$pidfile" ]; then
    echo "echo 37"
    pid=$(head -1 "$pidfile")
    if [ -z "$pid" ]; then
      echo "Unable to get pid from $pidfile"
      exit 1
    fi
    echo "echo 38"
    wait_pid $pid $try_kill $timeout $force

    rm -f $pidfile
  else
    echo "Pidfile $pidfile doesn't exist"
  fi
}

echo "echo 39"
kill_and_wait() {
  pidfile=$1
  echo "echo 40"
  # Monit default timeout for start/stop is 30s
  # Append 'with timeout {n} seconds' to monit start/stop program configs
  timeout=${2:-25}
  force=${3:-1}
  if [[ -f ${pidfile} ]]
  then
   echo "echo 41"
    wait_pidfile $pidfile 1 $timeout $force
  else
    echo "echo 42"
    # TODO assume $1 is something to grep from 'ps ax'
    pid="$(ps auwwx | grep "$1" | awk '{print $2}')"
    wait_pid $pid 1 $timeout $force
  fi
}
echo "echo 43"
check_nfs_mount() {
  opts=$1
  exports=$2
  mount_point=$3

  if grep -qs $mount_point /proc/mounts; then
    echo "echo 44"
    echo "Found NFS mount $mount_point"
  else
    echo "echo 45"
    echo "Mounting NFS..."
    mount $opts $exports $mount_point
    if [ $? != 0 ]; then
      echo "Cannot mount NFS from $exports to $mount_point, exiting..."
      exit 1
    fi
  fi
}
