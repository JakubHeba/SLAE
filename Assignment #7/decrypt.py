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

# opening key.key file with should be avaliable in the same folder
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
	# Taking encrypted shellcode from argv and decrypting using key provided in key.key file
	ciph = bytearray.fromhex(sys.argv[1].replace('\\x','')).decode()
	ciphAscii = bytes(ciph,'ascii')
	cipher = Fernet(key)
	dec = cipher.decrypt(ciphAscii)

	# replacing decrypted shellcode value with hexadecimal values in python/c style
	decrypted = str(dec)[2:-1].replace('\\\\','\\')

except cryptography.exceptions.InvalidSignature: 
	print("\nDecrypting failed! Wrong key. \n")
	quit()

except cryptography.fernet.InvalidToken:
	print("\nDecrypting failed! Wrong key. \n")
	quit()
print("\nSuccess!\n")

print("\n*** Decrypted shellcode: ***\n",30*"-","\n",decrypted,'\n',30*"-","\n")

# Execution part. Let's create a shellcode.c file template with variable containing our decrypted value in python/c style
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

# creating shellcode.c file
cShellcode = open("shellcode.c","w")
cShellcode.write(execute)
cShellcode.close()

decision = input("Would i try to execute a shellcode? [Y/N]  ")
if decision.lower() == "y" or decision.lower() == "yes":
	# compilation and execution of our decrypted shellcode
	os.system("gcc -fno-stack-protector -z execstack -m32 shellcode.c -o shellcode 2>/dev/null")
	os.system("./shellcode")	
	# Pwned.
else:
	print("\nExiting then.\n")
