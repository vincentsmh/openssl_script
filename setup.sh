ENC_SRC=enc.sh
DEC_SRC=dec.sh
DST_PATH=/usr/bin

function color_msg
{
	echo -e $3 "\033[$1m$2\033[0m"
}

sudo cp $ENC_SRC $DST_PATH/enc
sudo cp $DEC_SRC $DST_PATH/dec
sudo chmod 755 $DST_PATH/enc
sudo chmod 755 $DST_PATH/dec

echo -e
color_msg 32 "Please put your key at " -n
color_msg 33 "[$HOME/.key]"
echo -e
