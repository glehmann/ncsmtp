#!/bin/sh
#
# ncsmtpd start/stop script for Mandrake GNU/Linux
# Author: Gaëtan Lehmann <gaetan.lehmann@jouy.inra.fr>
#
# chkconfig: 345 80 20
# description: Starts and stops the Null Client SMTP deamon
#

# Source function library.
if [ -f /etc/init.d/functions ] ; then
  . /etc/init.d/functions
elif [ -f /etc/rc.d/init.d/functions ] ; then
  . /etc/rc.d/init.d/functions
else
  exit 0
fi

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ ${NETWORKING} = "no" ] && exit 0

LOCK_FILE=/var/lock/subsys/ncsmtpd
CONF_FILE=/etc/ncsmtp/main.conf
PATH=/sbin:/usr/sbin:/bin:/usr/bin
NAME="Null Client SMTP"
EXE=/usr/sbin/ncsmtpd

# Check that mail.conf exists.
if [ ! -f $CONF_FILE ]; then
	gprintf "Service not configured\n"
	exit 6 # not configured
fi

# Check that ncsmtpd exists
if [ ! -x $EXE ]; then
	gprintf "Service not installed\n"
	exit 5 # not installed
fi

RETVAL=0

start() {
	gprintf "Starting %s: " "$NAME"
	daemon $EXE --daemon --pid $CONF_FILE
	RETVAL=$?
	echo
	if [ $RETVAL -eq 0 ]; then
		touch $LOCK_FILE
	else
		RETVAL=1
	fi
	return $RETVAL
}	
stop() {
	gprintf "Stopping %s: " "$NAME"
	if [ -f /var/run/ncsmtpd.pid ] && [ -n "`cat /var/run/ncsmtpd.pid | xargs ps -o comm= -p`" ] ; then
		pid=`cat /var/run/ncsmtpd.pid`
		kill $pid
		sleep 0.1
		ps -o comm= -p $pid
		if [ ! -n "`ps -o comm= -p $pid`"] ; then
			kill -9 $pid
			sleep 0.1
		fi
		if [ -n "`ps -o comm= -p $pid`"] ; then
			success "stop"
			rm -f $LOCK_FILE
			rm -f /var/run/ncsmtpd.pid
			RETVAL=0
		else
			failure "stop"
			RETVAL=1
		fi
		echo
		return $RETVAL
	else
		failure "stop"
		echo
		return 1
	fi
}	
restart() {
	stop
	start
}

status() {
        if [ -f /var/run/ncsmtpd.pid ] && [ -n "`cat /var/run/ncsmtpd.pid | xargs ps -o comm= -p`" ] ; then
                gprintf "%s (pid %s) is running...\n" ncsmtp `cat /var/run/ncsmtpd.pid`
                return 0
        fi

        # Next try "/var/run/*.pid" files
        if [ -f /var/run/ncsmtpd.pid ] ; then
                read pid < /var/run/ncsmtpd.pid
                if [ -n "$pid" ] ; then
                        gprintf "%s dead but pid file exists\n" ncsmtp
                        return 1
                fi
        fi
        # See if /var/lock/subsys/ncsmtpd exists
        if [ -f /var/lock/subsys/ncsmtpd ]; then
                gprintf "%s dead but subsys locked\n" ncsmtp
                return 2
        fi
        gprintf "%s is stopped\n" ncsmtp
        return 3
}


case "$1" in
  start)
  	start
	;;
  stop)
  	stop
	;;
  restart)
  	restart
	;;
  status)
  	status
	;;
  condrestart)
  	[ -f $LOCK_FILE ] && restart || :
	;;
  *)
	gprintf "Usage: %s {start|stop|restart|status|condrestart}\n" "$0"
	exit 3 # unimplemented feature
esac

exit $?
