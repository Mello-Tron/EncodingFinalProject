TITLE Psuedo Random Number Generator

INCLUDE Irvine32.inc
							;R(n) = ((R(0) * K) + S) % MAX_NUM_CHAR
.data
inputString BYTE "apple&pie"
outputString BYTE "         "
R0 DWORD 4					;0 =< R(0) < MAX_NUM_CHAR
K DWORD 4					;0 < K < MAX_NUM_CHAR			K-1 is divisble by all prime factors of MAX_NUM_CHAR, K-1 is multiple of 4, if MAX_NUM_CHAR is a multiple of 4
S DWORD 7					;0 =< S < MAX_NUM_CHAR			MAX_NUM_CHAR and S are coprime
MAX_NUM_CHAR DWORD 9		;whatever character count is

.code
main PROC
	mov ebx, OFFSET inputString
	xor esi, esi
	mov eax, R0					;eax = R(0) or TIME ... in this case 300

L1:
	mul K						;edx:eax = R(0) * K
	add eax, S					;edx:eax = (R(0) * K) + S
	div MAX_NUM_CHAR			;edx = ((R(0) * K) + S) % MAX_NUM_CHAR which is R(n)
	mov eax, edx				;eax = "...see above..."

	mov ecx, OFFSET outputString		;ecx = OFFSET outputString
	add ecx, eax						;ecx = OFFSET outputString + R(n)
	xor edx, edx
	mov dl, BYTE PTR [ecx]				;edx = the character at R(n) location in outputString

	test edx, 11011111b					;test with " " which is 20h which is 00100000b
	jnz ShouldWeLoop					;lets jump if there is something other than an empty space

	push ebx

	push ecx							;Let's take the next letter from inputString and put it in outputString
	xor ecx, ecx
	mov cl, BYTE PTR [ebx]
	xor ebx, ebx
	mov bl, cl
	pop ecx

	mov [ecx], bl
	inc esi

	pop ebx
	inc ebx

ShouldWeLoop:
	cmp esi, MAX_NUM_CHAR
	je No
	jmp L1
No:

	;now check if esi == MAX_NUM_CHAR then {we are done} else {loop again}

exit
main ENDP
END main