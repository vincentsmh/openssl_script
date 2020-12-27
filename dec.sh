#!/bin/bash
KEY=~/.key

function decrypt_one()
{
	echo -ne "\033[1;36m$1\033[0m: "
	len=${#1}
	file_type1=${1:len-5}
	gz_name=${1:0:len-5}
	file_name=${1:0:len-8}
	len_fn=${#file_name}
	file_type_tar=${file_name:len_fn-4}

	# Decrypt a file.  Check if it is .des format first
	if [ "$file_type1" != ".des3" ]; then
		echo -e "The given file is not encrypted by DES3"
		exit 0
	fi

	# Start decrypting
	echo -ne "\033[1;34mDecrypting\033[0m ..."
	openssl enc -des3 -d -in "$1" -out "$gz_name" -kfile ${KEY}

	echo -ne "\033[1;35mDecompressing\033[0m ... "
	if [ "$file_type_tar" == ".tar" ]
	then
		tar zxvf "$gz_name"
		rm -f "$gz_name"
	else
		gzip -d "$gz_name"
	fi

	echo -e "\033[1;32mdone\033[0m"
}

function decrypt_all()
{

	for i in *.des3
	do
		decrypt_one "$i"
	done

	rm -f *.des3
}

# Check if argument is given.
if [ -z "$1" ]
then
	# If there is no given argument, recursively decrypt file one-by-one.
	echo -e
	echo -e "\033[1;32m === Decrypting all files under current directory \033[0m"
	echo -e
	decrypt_all
	echo -e
	echo -e
	echo -e "\033[1;32m === decryption finished === \033[0m"
else
	# Check if the given argument is a file or a directory
	if [ -d "$1" ]
	then
		# Cannot decrypt a directory
		echo -e "Sorry. Cannot decrypt a directory."
		echo -e "Please give a \033[1;33m.des\033[0m file."
	else
		if [ -f "$1" ]
		then
			decrypt_one "$1"
			rm -f "$1"
		else
			echo -e
			echo -e "File or directory does not exist."
			echo -e
		fi
	fi
fi
