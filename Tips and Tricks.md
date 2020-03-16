GDB Commands
-------------------------------------------------
gdb /bin/bash - Podłączenie procesu pod GDB
break main - Ustawienie breakpointu na funkcji
break *{adres w hex} - Ustawienie breakpointu w adresie w pamięci
run {argumenty} - Start procesu
info registers - Wyświetla zawartość rejestrów głównych/EFLAGS
info all-registers - Wyświetla zawartość wszystkich rejestrów
info functions - pokazuje funkcje w programie, jeśli ich nie znamy (pomocne przy breakpointach)
display -x $eax - Wyświetla zawartość konkretnego rejestru
disassemble $eip - Deasemblacja konkretnego adresu w rejestrze
disassemble main - Deasemblacja funkcji
set disassembly-flabor intel - Zmiana składni na Intelowską
info proc mappings - Pokazuje mapę procesu
stepi - wykonuję instrukcję w EIP i przechodzi jedną dalej
x/s {adres w pamięci} - wyświetla zawartość adresu jako string
x/xb {adres w pamięci{} - wyświetla zawartość zmiennej pod adresem
x/xb &var1 - wyświetla zawartość zmiennej var1
x/3xb &var2 - wyświetla zawartość będącą 3 bajtami zmiennej var2
shell readelf -h {binarka{} - wykonuje komendę systemową, która pokazuje m.in. entry point do breakpointa
info variables - pokazuje sekcję .data z przypisaniami zmiennymych do wartości (globalnymi)
print &zmienna - wskazuje adres zmiennej w pamięci
list - jeśli kod binarki jest w tym samym folderze, można go łatwo przeglądać
symbol-file {FILE_WITH_SYMBOLS} - dodanie symboli do binarki z poziomu gdb (unpersistance)
enable/disable/delete {breakpoint number} - włączanie/wyłączanie/usuwanie konkretnego breakpointa
info breakpoints - wyświetla listę breakpointów
continue - start po breakpoincie
set {char} 0x{adres} = 'B'
set {int} (0x{adres} +1) = 1
set {zmienna} = 1000
call {funkcja, np strcpy, albo jakaś własna, AddNumbers}(10,20)
set $i=100, set $j=200, call AddNumbers($i, $j)
condition {numer breakpointa} {warunek, np. counter == 5} - breakpointy warunkowe, odpala się tylko po spełnieniu warunku
define hook-stop - a następnie komendy, które chcemy wykonać po każdym STOP-ie, np. print/x $eax, disassemble $eip,+10, później wykonujemy nexti i obserwujemy efekt instrukcji po instrukcji
display/x $eax - działa podobnie jak hook, dodajemy linijki które będą wykonywały się po każdej instrukcji
-------------------------------------------------
Instrukcje
-------------------------------------------------
LEA - load pointer values - wczytuje adres wskaźnika do rejestru
LEA EAX,[label]

XCHG - zamienia wartości w dwóch rejestrach
XCHG Register/Register
XCHG Register/Memory
INC - Increment by one
DEC - Decrement by one
ADD Dest/Src - Dodawanie wartości
SUB Dest/Src - Odejmowanie wartości
CLC - Czyści flagę CF
STC - Nadaje flagę CF
CLD - Czyści flagę DF (Direction Flag)
STD - Nadaje flagę DF (Direction Flag)
CMC - Robi przeciwną flagę, jeśli jest CF - ściąga ją, jeśli nie ma - nakłada
ADC - Add with Carry, jeśli nie ma flagi, dodaje wartość, jeśli jest, dodaje wartość +1
SBB - Sub with Borrow, jeśli nie ma flagi, odejmuje wartość, jeśli jest, odejmuje wartość -1
MUL - mnożenie AL(8bit EAX), AX(16bit EAX), EAX(32bit EAX) przez wartość podaną po MUL, {wartość}. W przypadku 8 bitów, wynik ląduje w AX, w przypadku 16 bitów, Jeśli poniżej 16 bitów -> AX, jeśli ponad, DX i AX, w przypadku 32 bitów, jeśli poniżej, EAX, jeśli powyżej, EDX i EAX
DIV - dzielenie podobnie jak z mnożeniem, dzielimy składowe albo cały EAX przez wartość po DIV, {wartość}, a wynikiem jest (bez reszty) AL/AX/EAX oraz (reszta) w AH/DX/EDX. 
OR/NOR/AND/XOR - instrukcje warunkowe, przyjmujące dwie wartości i operujące na nich
W przypadku XOR-a, A XOR B daje C, a następnie C XOR A daje B i C XOR B daje A
JMP - Jump, który zawsze się wykona, bo nie ma warunku
JNZ - Jump, jeśli nie ma flagi Zero, w przeciwnym wypadku, instrukcja jest omijana
LOOP - działa jak pętla z JNZ; operuje na ECX i dekrementuje go do momentu, aż osiągnie zero, wtedy puszcza flow dalej
CALL - wywołuje procedurę
PUSHAD - wrzuca na stack zawartość wszystkich rejestrów w kolejności EAX, ECX, EDX, EBX, EBP, ESP (original value), EBP, ESI, and EDI
PUSHFD - dekrementuje stack pointer o 4 i wrzuca zawartość EFLAGS na stack
POPFD - Bierze 4 bajty ze stacku i wrzuca je w rejestr EFLAGS
POPAD - Bierze 8 bajtów ze stacku i wrzuca je w rejestry w kolejności: EDI, ESI, EBP, EBX, EDX, ECX, and EAX
REP - Repeat, powtarza instrukcję która jest jako argument tyle razy, aż ECX będzie 0, dekrementując jego wartość po każdej itaracji
REPE CMPSB - Repeat while equal, compares bytes - Porównuje każdy bajt dwóch stringów i jeśli cały string jest identyczny, ustawia flagę ZF, jeśli s różne, nie ustawia
-------------------------------------------------
Pętle
-------------------------------------------------
Improwizacja pętli za pomocą JNZ:
Begin:
	mov EAX, 0x5
PrintHW:
	push EAX
	---------------------------
	{hello world instructions}
	---------------------------
	pop EAX
	dec EAX
	jnz PrintHW	
-------------------------------------------------
Pętla za pomocą LOOP:
Begin:
	mov ECX, 0x5
PrintHW:
	push ECX
	---------------------------
	{hello world instructions}
	---------------------------
	pop ECX
	LOOP PrintHW
-------------------------------------------------
FLAGI
-------------------------------------------------
ZF - kiedykolwiek jakaś operacja kończy się umieszczeniem zera w rejestrze, nadawana jest flaga Zero
CF - Carry Flag. nadawana na żądanie, np. STC, albo w przypadku przeniesienia liczby w przód lub w tył (np. 30+90 = 120, jeden do przodu, nadawana jest flaga CF. podobnie przy odejmowaniu. FFFFFFFF + 10 = F + CF)
int 0x80 działa jako call, kernel dostaje sygnał i wykonuje syscall który ma w EAX
/usr/include/i386-linux-gnu/asm/unistd_32.h - pełny spis wszystkich syscalls wraz z numerami
man 2 write - przykład pomocy przy funkcji write() w którym możemy znaleźć m.in. opis parametrów
objcopy --only-keep-debug Binary_From Binary_To - kopiuje symbole z binarki
strip --strip-debug --strip-unneeded Binary_To - wycina symbole z binarki
objcopy --add-gnu-debuglink={DEBUG_FILE} {BINARY}
nm ./{binarka} - analiza symboli w różnych sekcjach 
strace -e [syscalle, np. open, socket, connect, recv] {executable} arguments - śledzi wywołanie programu i wszystkie syscalle, które wykorzystuje
strace -p {process_id} - śledzenie działającego procesu
strace -c {executable} arguments - wyświetla tabelę z wszystkimi syscallami w binarce
-------------------------------------------------
Procedury
-------------------------------------------------
Wywołuje się je rejestrem CALL
Składają się z kodu zakończonego rejestrem RET
ProcedureName:
	..code..
	..code..
	..code..
	RET

W przypadju pętli, również posługujemy się POP-em i PUSH-em:
PrintHelloWorld:
	push ecx
	call HelloWorld
	pop ecx
	loop PrintHelloWorld
-------------------------------------------------	
JMP-CALL-POP exploit

Wykorzystywany, aby ominąć konieczność umieszczania adresu w shellcodzie, na przykład referencji do zmiennej. 

section .text

_start:

	jmp short Call_Shellcode <--- Short jump do procedury Call_Shellcode

shellcode:

	<shellcode instructions>
	pop ecx <--- w tym miejscu wywoływany jest adres ze stacku, który znajduje się na samej górze, a jest nim nasz referencja zmiennej z Call_Shellcode
	<shellcode instructions>

Call_Shellcode:
	call shellcode <--- w momencie wywołania procedury, na "Top of the stack" wrzucany jest adres kolejnej instrukcji, a więc naszej zmiennej HelloWorld
	HelloWorld db "Hello World!", 0xA
-------------------------------------------------
Kolejną techniką obejścia powyższego problemu jest wykorzystanie stacku (ESP)
Zerujemy EDX i wrzucamy go na stack:

	xor edx, edx
	push edx

Następnie, wrzucamy nasz string w REVERSE ORDER (ze względu na specyfikę stacku, z tego też względu wrzuciliśmy 4 null byte'y powyżej, aby był string terminator)

	push 0x0a646c72
	push 0x6f57206f
	push 0x6c6c6548

Następnie, wrzucamy Top of the Stack (ESP) wskazujący na nasz 'Hello World' w ECX

	mov ecx, esp

-------------------------------------------------
Wykonywanie komend w shellcode. Metoda STACK:

	; wrzucamy null DWORD-a
	xor eax, eax
	push eax

	; PUSH /path/do/komendy, tak, aby była podzielna przez 4, dodając ////
	push 0x{}
	push 0x{} <-- komenda musi być w reverse order, z racji na stack
	push 0x{}

	mov ebx, esp <-- Top of the Stack wrzucamy w EBX

	push eax
	push edx, esp

	push ebx
	push ecx, esp

	mov al, 11
	int 0x80

-------------------------------------------------
OBJDUMP one liner hex extracter:

objdump -d ./xor-decoder|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'

-------------------------------------------------
GCC Compilation

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode

-------------------------------------------------
Używanie MMX przy xorowaniu:

_start:
	jmp short call_decoder

decoder:
	pop edi
	lea esi, [edi+8]
	xor ecx, ecx
	mov cl, 4

decode:
	movq mm0, qword [edi]
	movq mm1, qword [esi]
	pxor mm0, mm1
	movq qword [esi], mm0
	add esi, 0x8
	loop decode

	jmp short

call_decoder:

	call decoder
	decoder_value: db 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa
	EncodedShellcode: db {shellcode}
