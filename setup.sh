#!/bin/sh
if [ `id -u` != "0" ]
then echo "please execute as super-user: sudo $0 $*" 1>&2
exit 1
fi

D=/home/web/template/php
cd $D
cmd=${1:-setup-directories}

if [ "$cmd" = "setup-directories" ]
then
	mkdir log run
	touch log/fpm-access.log log/php.log log/access.log log/error.log
	chown web.root log/fpm-access.log log/php.log
	chown root.root log/access.log log/error.log
	chmod 660 log/fpm-access.log log/php.log log/access.log log/error.log
	
	chown web.web .
	chmod 755 .
	chmod 755 htdocs
	chown root.www-data run
	chmod 750 run
elif [ "$cmd" = "fpm" ]
then
	shift
	args="${*:-}"	# to get information use --info, --modules or --version
				# test with -t or -tt and --nodaemonize and --force-stderr
	php5-fpm --php-ini "$D/conf/php.ini" --fpm-config "$D/conf/php-fpm.conf" --pid "$D/run/php-fpm.pid" $args
	chown www-data.www-data run/fpm.sock
	chmod 660 run/fpm.sock
elif [ "$cmd" = "fpmstop" ]
then kill `cat run/php-fpm.pid`; rm run/fpm.sock
elif [ "$cmd" = "fpmrestart" ]
then
	shift
	$0 fpmstop
	$0 fpmstart $*
elif [ "$cmd" = "activate" ]
then
	ln -s /home/web/template/php/conf/php-vhost.conf /etc/apache2/sites-enabled/php-template.conf
	ln -s /home/web/template/php/conf/php-nginx.conf /etc/nginx/sites-enabled/php-template.conf
elif [ "$cmd" = "deactivate" ]
then
	rm /etc/apache2/sites-enabled/php-template.conf
	rm /etc/nginx/sites-enabled/php-template.conf
elif [ "$cmd" = "apache-reload" ]
then
	service apache2 reload
elif [ "$cmd" = "nginx-reload" ]
then
	service nginx reload
elif [ "$cmd" = "apache-service-log" ]
then
	systemctl -l status apache2.service
elif [ "$cmd" = "nginx-service-log" ]
then
	systemctl -l status apache2.service
elif [ "$cmd" = "clean-logs" ]
then
	for x in access error fpm-access php 
	do echo -n "" > log/"$x".log
	done
fi