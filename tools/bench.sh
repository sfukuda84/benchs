#!/bin/sh

yum install -y libXext-devel freeglut greeglut-devel gcc make perl-Time-HiRes > /dev/null

BENCH_DIR=${HOME}/benchs
UB_DIR=/opt/UnixBench

if [ ! -d ${UB_DIR} ]; then
  cd /opt
  curl http://byte-unixbench.googlecode.com/files/UnixBench5.1.3.tgz | tar zx
fi
if [ -d ${BENCH_DIR}  ]; then
  rm -rf ${BENCH_DIR}/*
else
  mkdir -p ${BENCH_DIR}
fi
cd ${BENCH_DIR}
mkdir proc
mkdir disk
mkdir ub
cat /proc/version > proc/version.log 
cat /proc/cpuinfo > proc/cpuinfo.log
cat /proc/meminfo > proc/meminfo.log
fdisk -l > disk/fdisk.log
df -h > disk/df.log
TESTS=(fs shell arithmetic misc index)
cd ${UB_DIR}
for test in ${TESTS[@]}; do
  ./Run ${test} > ${BENCH_DIR}/ub/${test}.log
done
cd ${HOME}
[ -f benchs.tgz ] && rm -rf benchs.tgz
tar czf benchs.tgz benchs
