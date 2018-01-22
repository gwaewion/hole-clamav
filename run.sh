#!/bin/sh

if [ -f /clamav/db/main.cvd ]
then
	freshclam -d --daemon-notify=/etc/clamav/clamd.conf
	clamd
	clamsmtpd -d 4
else
	mkdir /clamav/log /clamav/db
	cp -R /var/lib/clamav/* /clamav/db/
	chown -R clamav:clamav /clamav
	freshclam -d --daemon-notify=/etc/clamav/clamd.conf
	clamd
	clamsmtpd -d 4
fi