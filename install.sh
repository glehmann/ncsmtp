#!/bin/sh -x

mkdir -p $DESTDIR/usr/sbin
mkdir -p $DESTDIR/etc/rc.d/init.d
mkdir -p $DESTDIR/etc/ncsmtp

install -m 755 ncsmtpd  $DESTDIR/usr/sbin
install -m 644 main.conf aliases $DESTDIR/etc/ncsmtp
install -m 755 ncsmtp.init.d $DESTDIR/etc/rc.d/init.d/ncsmtp

