#!/bin/sh

darcs dist --dist-name ncsmtp-`cat version`
bzme -f ncsmtp-`cat version`.tar.gz
