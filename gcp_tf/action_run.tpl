#!/bin/bash 
# This installs and runs masscan, use it for whatever you would like though. 

apt -y update
apt -y install build-essential git gcc make libpcap-dev

cd /root
git clone https://github.com/robertdavidgraham/masscan
cd masscan
make

gsutil cp gs://${bucket}/${scan_list} .

bin/masscan --top-ports 50 -iL ${scan_list} --rate 500 --excludefile data/exclude.conf -oB results-${count}.masscan.bin --shard ${count}/${total}

gsutil cp results-${count}.masscan.bin gs://${bucket}/results-${count}.masscan.bin
