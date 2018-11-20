#!/usr/bin/env bash

# This helps keep the ctl script as readable
# as possible

# Usage options:
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh JOB_NAME OUTPUT_LABEL
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar foobar
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar nginx

set -e # exit immediately if a simple command exits with a non-zero status
set -u # report the usage of uninitialized variables

echo "echo 1"
JOB_NAME=$1
echo "echo 2"
output_label=${1:-JOB_NAME}

echo "echo 3"
export JOB_DIR=/var/vcap/jobs/$JOB_NAME
echo "echo 4"
chmod 755 $JOB_DIR # to access file via symlink
echo "echo 5"
# Load some bosh deployment properties into env vars
# Try to put all ERb into data/properties.sh.erb
# incl $NAME, $JOB_INDEX, $WEBAPP_DIR

source $JOB_DIR/data/properties.sh
echo "echo 5"
source $JOB_DIR/helpers/ctl_utils.sh
redirect_output ${output_label}
echo "echo 6"
export HOME=${HOME:-/home/vcap}

# Add all packages' /bin & /sbin into $PATH
echo "echo 7"
for package_bin_dir in $(ls -d /var/vcap/packages/*/*bin)
do
  export PATH=${package_bin_dir}:$PATH
done

echo "echo 8"
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-''} # default to empty
echo "echo 9"
for package_bin_dir in $(ls -d /var/vcap/packages/*/lib)
do
  export LD_LIBRARY_PATH=${package_bin_dir}:$LD_LIBRARY_PATH
done

# Setup log, run and tmp folders

echo "echo 10"
export RUN_DIR=/var/vcap/sys/run/$JOB_NAME
export LOG_DIR=/var/vcap/sys/log/$JOB_NAME
export TMP_DIR=/var/vcap/sys/tmp/$JOB_NAME
export STORE_DIR=/var/vcap/store/$JOB_NAME
echo "echo 11"
for dir in $RUN_DIR $LOG_DIR $TMP_DIR $STORE_DIR
do
  echo "echo 12"
  mkdir -p ${dir}
  chown vcap:vcap ${dir}
  chmod 775 ${dir}
done
echo "echo 13"
export TMPDIR=$TMP_DIR

if [[ -d /var/vcap/packages/java ]]
then
  echo "echo 14"
  export JAVA_HOME="/var/vcap/packages/java"
fi

# setup CLASSPATH for all jars/ folders within packages
#export CLASSPATH=${CLASSPATH:-''} # default to empty
#for java_jar in $(ls -d /var/vcap/packages/*/*/*.jar)
#do
#  export CLASSPATH=${java_jar}:$CLASSPATH
#done

echo "echo 15"
PIDFILE=$RUN_DIR/$JOB_NAME.pid

echo "echo 16"
echo '$PATH' $PATH

echo "echo 17"
chown vcap:vcap ${JOB_DIR}/data
echo "echo 18"
chmod 755 ${JOB_DIR}/data
