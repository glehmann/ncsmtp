#!/bin/sh

mkdir -p $DESTDIR/usr/bin
mkdir -p $DESTDIR/etc/rc.d/init.d
mkdir -p $DESTDIR/etc/ncsmtp

install -m 755 ncsmtpd  $DESTDIR/usr/bin
install -m 644 main.conf aliases $DESTDIR/etc/ncsmtp

