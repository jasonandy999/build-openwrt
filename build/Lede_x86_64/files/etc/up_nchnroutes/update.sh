#!/bin/bash
#https://github.com/daysdragon/nchnroutes
# AutoUPdate Module by daysdragon
# AutoUpdate ip for Openwrt brid

echo "start ing..."

if [ "$(curl -o ipv4-address-space.csv https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.csv -w '%{http_code}')" = "200" ]; then
	echo "down ipv4-address-space.csv OK"
	if [ "$(curl -o delegated-apnic-latest https://ftp.apnic.net/stats/apnic/delegated-apnic-latest -w '%{http_code}')" = "200" ]; then
		echo "down delegated-apnic-latest OK"
	else
		echo "down delegated-apnic-latest error"
		exit 0
	fi
else
	echo "down ipv4-address-space.csv error"
	exit 0
fi
#curl -o ipv4-address-space.csv https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.csv -w '%{http_code}'
#curl -o delegated-apnic-latest https://ftp.apnic.net/stats/apnic/delegated-apnic-latest -w '%{http_code}'
echo "start produce.py ing..."
python3 produce.py --next 192.168.100.252

echo "mv routes4.conf ing..."
mv routes4.conf /etc/routes4.conf

# sudo mv routes6.conf /etc/bird/routes6.conf

echo "bird reload ing..."
/etc/init.d/bird reload

echo "TASK OK"