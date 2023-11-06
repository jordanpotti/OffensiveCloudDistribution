#!/bin/bash 
# This makes and runs masscan, use it for whatever you would like though. 

apt update -y 
apt install git -y
apt install build-essential -y
apt install python-pip -y
snap install aws-cli --classic
pip install yq
apt install jq -y
sudo apt-get install git gcc make libpcap-dev -y
git clone https://github.com/robertdavidgraham/masscan
cd masscan
make -j

apt install nmap -y
# Format the date as 'YYYY-MM-DD'

sudo git clone https://github.com/scipag/vulscan scipag_vulscan
sudo ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan


/snap/bin/aws s3 cp s3://${s3_bucket}/${scan_list} .

# do only port scan no banner grabbing, output to binary file
#sudo bin/masscan --top-ports 50 -iL ${scan_list} --rate 500 --excludefile data/exclude.conf -oB results-${count}.masscan.bin --shard ${count}/${total} --seed 10

# same, but output -oG masscan_results.txt, and run nmap on the results
sudo bin/masscan --top-ports 50 -iL ${scan_list} --rate 500 --excludefile data/exclude.conf -oG masscan_results.txt --shard ${count}/${total} --seed 10
awk '/open/ {split($7,a,"/"); print $4":"a[1]}' masscan_results.txt > nmap_targets.txt
while IFS=: read -r ip port; do
    sudo nmap -sV -p $port $ip --script=vulscan/vulscan.nse --script-args vulscandb=cve.csv -P0 -oX "nmap_results_$ip.xml"
done < nmap_targets.txt

# upload results to s3 (txt) folder is date
for file in nmap_results_*.xml; do
    /snap/bin/aws s3 cp "$file" s3://${s3_bucket}/$(date +%F)/"$file"
done

# upload results to s3 (bin)
#/snap/bin/aws s3 cp results-${count}.masscan.bin s3://${s3_bucket}/results-${count}.masscan.bin



 