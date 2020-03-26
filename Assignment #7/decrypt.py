#!/usr/bin/python3
from cryptography.fernet import Fernet
import sys
import binascii
import base64
import codecs
import os
import time
import cryptography
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

file = open('key.key','rb')
key = file.read()
file.close()

if len(sys.argv) != 2:
    print("\nUsage: python3 decrypter.py {shellcode}\n")
    print("Example:\npython3 decrypter.py \"\\x31\\xc0\\xeb\\x20\\x5b\\x31\\xc0\\xeb\\x20\\x5b\\\"\n")
    quit()

print("\n/--------------------------------/")
print(" ***  Fernet AES Decrypter.  ***")
print("/--------------------------------/\n\n")

print("Loading key from key.key file, please wait ...\n\n")
print("*** Key loading completed! Content: ***\n",30*'-',"\n",key.decode("utf-8"),"\n")
print("Trying to decrypt the shellcode using key provided ...")
print("3..")
time.sleep(1)
print("2...")
time.sleep(1)
print("1...")
time.sleep(1)
try:
	ciph = bytearray.fromhex(sys.argv[1].replace('\\x','')).decode()
	ciphertext = bytes(ciph,'ascii')
	cipher = Fernet(key)
	plaintext = cipher.decrypt(ciphertext)

	decrypted = str(plaintext)[2:-1].replace('\\\\','\\')

except cryptography.exceptions.InvalidSignature: 
	print("\nDecrypting failed! Wrong key. \n")
	quit()

except cryptography.fernet.InvalidToken:
	print("\nDecrypting failed! Wrong key. \n")
	quit()
print("\nSuccess!\n")

print("\n*** Decrypted shellcode: ***\n",30*"-","\n",decrypted,'\n',30*"-","\n")

execute = """
#include<stdio.h>
#include<string.h>

unsigned char code[] = \\
\""""+decrypted+"""\";
main()
{

	printf(\"Shellcode Length:  %d\\n\", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}"""
cShellcode = open("shellcode.c","w")
cShellcode.write(execute)
cShellcode.close()

decision = input("Would i try to execute a shellcode? [Y/N]  ")
if decision.lower() == "y" or decision.lower() == "yes":
	os.system("gcc -fno-stack-protector -z execstack -m32 shellcode.c -o shellcode")
	os.system("./shellcode")	
	else:
	print("\nExiting then.\n")
