#!/bin/bash 
# This makes and runs masscan, nmap, and whatwaf

apt update -y 
apt install git -y
apt install build-essential -y
apt install python3-pip -y
snap install aws-cli --classic
# pip install yq
# apt install jq -y
git clone https://github.com/Ekultek/WhatWaf.git
cd WhatWaf
sudo pip install -r requirements.txt
echo root | python setup.py install
cd /
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
echo 'shards - ${count}/${total} '
sudo bin/masscan --top-ports 50 -iL ${scan_list} --rate 500 --excludefile data/exclude.conf -oG masscan_results.txt --shard ${count}/${total} --seed 10
awk '/open/ {split($7,a,"/"); print $4":"a[1]}' masscan_results.txt > nmap_targets.txt
while IFS=":" read -r ip port; do

temp_file="temp_nmap_$ip-$port.xml"
result_file="nmap_results_$ip-$port.xml"

# Perform the nmap scan and output to a temporary file
sudo nmap -p $port -Pn -T4 --open --script http-headers,http-title --script-args http.useragent="A friendly web crawler (https://rescana.com)",http-headers.useget $ip -oX $temp_file

# Check if grep finds 'http-headers', and if so, save to the final file
if grep -q "| http-headers:" "$temp_file"; then
    grep "| http-headers:" "$temp_file" > "$result_file"
fi

# Optionally, remove the temporary file
#rm "$temp_file"

done < nmap_targets.txt

# parse the ip and port from the results files, put each in a new whatwaf target file twice, once with  "http://" and once with "https://" in the begning and add the port number to the ip address so we get a valid url
while IFS=: read -r ip port; do
    echo "http://$ip:$port" >> whatwaf_targets.txt
    echo "https://$ip:$port" >> whatwaf_targets.txt
done < nmap_results_*.xml   ## this is probably wrong fix from here!!!!!!!

# next step - run whatwaf on the results   
python whatwaf.py -t whatwaf_targets.txt -r whatwaf_results.txt


# upload results to s3 (txt) folder is date
for file in nmap_results_*.xml; do
    /snap/bin/aws s3 cp "$file" s3://${s3_bucket}/$(date +%F)/"$file"
done

# upload results to s3 (bin)
#/snap/bin/aws s3 cp results-${count}.masscan.bin s3://${s3_bucket}/results-${count}.masscan.bin

