#!/bin/sh

date=$(date +%Y%m%d)
filename="sfol_$date.zip"

url="https://addons.mozilla.org/firefox/downloads/latest/474623/addon-474623-latest.xpi?src=dp-btn-primary"
wget $url -O docs/$filename