#!/bin/bash
KEY=~/.key
dont_rm=0

function rm_tail_slash()
{
	len=${#1}
	end_char=${1:len-1}
	if [ $end_char == "/" ]; then
		revised_name=${1:0:len-1}
		echo $revised_name
	else
		echo "$1"
	fi
}

function encrypt_one()
{
  if [ -d "$1" ]; then
    fn=$(rm_tail_slash "$1")
    # Encrypt a directory
    echo -e "$fn: "
    echo -e "\033[0;33mCompressing\033[0m ..."
    tar zcvf "$fn.tar.gz" "$fn"
    echo -ne "\033[0;33mEncrypting\033[0m ... "
    openssl enc -des3 -e -in "$fn.tar.gz" -out "$fn.tar.gz.des3" -kfile ${KEY}
    echo -e "\033[0;32mdone\033[0m"

    if [ -f "$fn.tar.gz.des3" ]; then
      rm -f "$fn.tar.gz"
      if [ ${dont_rm} -eq 0 ]; then
        rm -rf "$fn"
      fi
    fi
	else
    if [ -f "$1" ]; then
      # Encrypt a file
      len=${#1}
      check_gz=${1:len-3:$len}
      check_des3=${1:len-5:$len}
      in="$1"
      out="$1.des3"

      echo -ne "$1: "

      # The file has been encrypted.
      if [ $check_des3 == ".des3" ]; then
        echo -e "\033[0;31mAlready encrypted\033[0m"
        return 0
      fi

      # Check if the file has been compressed
      local keep_gz_f=0
      if [ $check_gz != ".gz" ]; then
        keep_gz_f=1
        echo -ne "\033[0;34mCompressing\033[0m ... "
        if [ $dont_rm -ne 0 ]; then
          gzip -c "$1" > "$1.gz"
        else
          gzip -9 "$1"
        fi

        in="$1.gz"
        out="$1.gz.des3"
      fi

      echo -ne "\033[0;35mEncrypting\033[0m ... "
      openssl enc -des3 -e -in "$in" -out "$out" -kfile ${KEY}
      echo -e "\033[0;32mdone\033[0m"

      if [ -f "$out" ]; then
        if [ ${dont_rm} -eq 0 ]; then
          rm -f "$1"
        fi

        if [ $keep_gz_f -eq 1 ]; then
          rm -f $in
        fi
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
if [ "$1" == "-dr" ]; then
  dont_rm=1
  shift 1
fi

if [ -z "$1" ]; then
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
