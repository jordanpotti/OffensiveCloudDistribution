## Default Actions

The default action here kicks off a masscan on the scan list you specify. Take a look at `action_run.tpl` to see what exactly the script is doing. 

Masscan has a shard option which makes it trivial to split scans up by sharding the scans among the servers spun up by Terraform. Other tools don't have the feature so using a tool like [splitter](https://github.com/jordanpotti/splitter) will let you split a file up and using the `count` variable, specify what list you'd like to scan. 

A template to get you started splitting lists of hosts to scan:

```
/snap/bin/aws s3 cp s3://${s3_bucket}/${scan_list} .

curl https://github.com/jordanpotti/splitter/releases/download/Linux/splitter -L --output splitter

chmod +x splitter

./splitter -target ${scan_list} -numb ${total}

git clone <insert cool tool here>

cd <insert cool tool here>

./<cool tool> --target ${count} --out ${count}.out

/snap/bin/aws s3 cp ${count}.out s3://${s3_bucket}/${count}.out
```
### Troubleshooting
To verify a scan kicked off, or troubleshoot an action, SSH into one of your servers and run `tail -f /var/log/cloud-init-output.log`, that will also let you track the progress of your scans.
