#!/bin/bash
KEY=~/.key

function check_end_char()
{
	len=${#1}
	end_char=${1:len-1}
	if [ $end_char == "/" ]
	then
		revised_name=${1:0:len-1}
		echo $revised_name
	else
		echo "$1"
	fi
}

function encrypt_one()
{
	if [ -d "$1" ]
	then
		fn=$(check_end_char "$1")
		# Encrypt a directory
		echo -e "$fn: "
		echo -e "\033[0;33mCompressing\033[0m ..."
		tar zcvf "$fn.tar.gz" "$fn"
		echo -ne "\033[0;33mEncrypting\033[0m ... "
		openssl enc -des3 -e -in "$fn.tar.gz" -out "$fn.tar.gz.des3" -kfile ${KEY}
		echo -e "\033[0;32mdone\033[0m"

		if [ -f "$fn.tar.gz.des3" ]
		then
			rm -f "$fn.tar.gz"
			rm -rf "$fn"
		fi
	else
		if [ -f "$1" ]
		then
			# Encrypt a file
			len=${#1}
			check_gz=${1:len-3:$len}
			check_des3=${1:len-5:$len}
			in="$1"
			out="$1.des3"

			echo -ne "$1: "

			# The file has been encrypted.
			if [ $check_des3 == ".des3" ]
			then
				echo -e "\033[0;31mEncrypting unnecessary.\033[0m"
				return 1
			fi

			# Check if the file has been compressed
			if [ $check_gz != ".gz" ]
			then
				echo -ne "\033[0;34mCompressing\033[0m ... "
				gzip -9 "$1"
				in="$1.gz"
				out="$1.gz.des3"
			fi

			echo -ne "\033[0;35mEncrypting\033[0m ... "
			openssl enc -des3 -e -in "$in" -out "$out" -kfile ${KEY}
			echo -e "\033[0;32mdone\033[0m"

			if [ -f "$out" ]
			then
				rm -f "$in"
			fi

				else
					echo -e
					echo -e "File or directory does not exist."
					echo -e
				fi
			fi
}

function encrypt_all()
{
	for i in *
	do
		encrypt_one "$i"
	done
}

# Check if argument is given.
if [ -z "$1" ]
then
	# If there is no given argument, recursively encrypt file one-by-one.
	echo -e
	echo -e "\033[1;32m === Encrypting all files under current directory \033[0m"
	echo -e
	encrypt_all
	echo -e
	echo -e
	echo -e "\033[1;32m === Encryption finished === \033[0m"
else
	encrypt_one "$1"
fi
