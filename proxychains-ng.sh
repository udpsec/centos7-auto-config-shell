#!/bin/sh
# Usage:
#   wget -O- https://gist.githubusercontent.com/ifduyue/dea03b4e139c5758ca114770027cf65c/raw/install-proxychains-ng.sh | sudo bash -s

set -eu

version=4.13
wget https://github.com/rofl0r/proxychains-ng/archive/v$version.tar.gz
tar xf v$version.tar.gz


(cd proxychains-ng-$version
 ./configure
 make
 make install
 [[ -f /etc/proxychains.conf ]] || cp src/proxychains.conf /etc/proxychains.conf
)

rm -rf v$version.tar.gz proxychains-ng-$version
