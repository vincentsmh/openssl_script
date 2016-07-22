#!/bin/bash

ENC_SRC=enc.sh
DEC_SRC=dec.sh
DST_PATH=/usr/local/bin

function color_msg
{
	echo -e $3 "\033[$1m$2\033[0m"
}

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

cp $ENC_SRC $DST_PATH/enc
cp $DEC_SRC $DST_PATH/dec
chmod 755 $DST_PATH/enc
chmod 755 $DST_PATH/dec

echo -e
color_msg 32 "Please put your key at " -n
color_msg 33 "[$HOME/.key]"
echo -e
