Introduction
============
Use openssl (des3) to encrypt and decrypt files and folers.


Installation
============
bash setup.sh

How to use
==========
1. Put enc.sh and dec.sh to home folder ~ (or whereever you want to).

2. Create your key at `~/Desktop/.key`: Just edit a file and type what you want to be the key.  
	`vim ~/Desktop/.key`  
	Type whatever you want to be the key

3. Encrypt/Decrypt a file/folder:  
	`~/enc.sh file/folder`  
	`~/dec.sh file.des3`  

4. Encrypt/Decrypt all files under a folder:  
	`~/enc.sh`  
	`~/dec.sh`

Changelog
=========
+ [06/03/2012] Fix a bug that dec.sh can not decrypt file which contains a 
  space " " in its file name.
+ [06/03/2012] Revise README file to use markdown syntax and merge HOW-TO-USE
  into README.
