#!/bin/bash 
# This makes and runs masscan, use it for whatever you would like though. 

apt update -y 
apt install git -y
apt install build-essential -y
snap install aws-cli --classic

sudo apt-get install git gcc make libpcap-dev
git clone https://github.com/robertdavidgraham/masscan
cd masscan
make -j

/snap/bin/aws s3 cp s3://${s3_bucket}/${scan_list} .

sudo bin/masscan --top-ports 50 -iL ${scan_list} --rate 500 --excludefile data/exclude.conf -oB results-${count}.masscan.bin --shard ${count}/${total}

/snap/bin/aws s3 cp results-${count}.masscan.bin s3://${s3_bucket}/results-${count}.masscan.bin



 