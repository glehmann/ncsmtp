#!/bin/sh -x

# darcs changes > ChangeLog
perl -pi -e "s/^%define version\s+.+$/%define version\t\t`cat version`/g" ncsmtp.spec
rm -f predist.sh makedist.sh
chmod +x install.sh
