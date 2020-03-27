#!/usr/bin/python3
from cryptography.fernet import Fernet
import sys
#import binascii
import base64
import os
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

# configuring variables for key generation
passwd = "SLAE"
password = passwd.encode()
salt = b'%s' % os.urandom(16)

kdf = PBKDF2HMAC(
    algorithm=hashes.SHA256(),
    length=32,
    salt=salt,
    iterations=100000,
    backend=default_backend()
)
key = base64.urlsafe_b64encode(kdf.derive(password))

# saving generated, unique key to the key.key file
file = open('key.key','wb')
file.write(key)
file.close()

if len(sys.argv) != 2:
    print("\nUsage: python3 crypter.py {shellcode}\n")
    print("Example:\npython3 crypter.py \"\\x31\\xc0\\xeb\\x20\\x5b\\x31\\xc0\\xeb\\x20\\x5b\\\"\n")
    quit()

print("\n/--------------------------------/")
print(" ***  Fernet AES Encrypter.  ***")
print("/--------------------------------/")

print("\n\n*** Generated key: *** \n",30*'-',"\n", key.decode("utf-8"))

# Taking shellcode from argv and encrypting using generated key
plainAscii = bytes(sys.argv[1],'ascii')
cipher = Fernet(key)
ciphAscii = cipher.encrypt(plainAscii)

print("\n*** Original Shellcode: ***\n",30*"-","\n",sys.argv[1])           
print("\n*** Data after encryption: ***\n",30*'-',"\n", ciphAscii.decode("utf-8"))

# Replacing encrypted shellcode value with hexadecimal values in python style
shell = r"\x" + r"\x".join(ciphAscii.hex()[n : n+2] for n in range(0, len(ciphAscii.hex()), 2))
print("\n*** Encrypted shellcode: ***\n",30*"-","\n",'"',shell,'"')


