TITLE Psuedo Random Number Generator & Encryption

INCLUDE Irvine32.inc
							;R(n) = ((R(0) * K) + T) % MAX_NUM_CHAR
.data
inputString BYTE "012345678901234567890123456789012345678901234567890123456789012345678912"
outputString BYTE "                                                                        "
R0 DWORD 71					;0 =< R(0) < MAX_NUM_CHAR
K DWORD 13					;0 < K < MAX_NUM_CHAR			K-1 is divisble by all prime factors of MAX_NUM_CHAR, K-1 is multiple of 4, if MAX_NUM_CHAR is a multiple of 4
T DWORD 5					;0 =< T < MAX_NUM_CHAR			MAX_NUM_CHAR and T are coprime
MAX_NUM_CHAR DWORD 72		;whatever character count is

.code
main PROC
	push T
	push MAX_NUM_CHAR
	push OFFSET inputString
	push R0
	push OFFSET outputString
	push K

	call PseudoRandEncrypt

exit
main ENDP

;--------------------------------------------------------------------------------
PseudoRandEncrypt PROC USES esi, _K:DWORD, _output:DWORD, _R0:DWORD, _input:DWORD, _MAX:DWORD, _T:DWORD
;Generates a random integer between 0 and (MAX_NUM_CHAR - 1).
;Recieves: _K: K constant, _output: OFFSET outputString, _R0: Seed
;		   _input: OFFSET inputString, _MAX: Max number of characters, _T: T constant
;Returns:
;--------------------------------------------------------------------------------
	xor esi, esi				;esi = 0

	mov eax, _R0
	mov ebx, _input
	mov ecx, _output

L1:
	mov edx, _K
	mov edi, _T

	mul edx						;edx:eax = R(0) * K
	add eax, edi				;edx:eax = (R(0) * K) + T
	div _MAX					;edx = ((R(0) * K) + T) % MAX_NUM_CHAR which is R(n)
	mov eax, edx				;eax = "...see above..."

	mov edi, ecx						;edi = OFFSET outputString
	add edi, eax						;edi = OFFSET outputString + R(n)
	xor edx, edx
	mov dl, BYTE PTR [edi]				;edx = the character at R(n) location in outputString

	test edx, 11011111b					;test with " " which is 20h which is 00100000b
	jnz ShouldWeLoop					;lets jump if there is something other than an empty space

	push ebx

	push ecx							;Let's take the next letter from inputString and put it in outputString
	xor ecx, ecx
	mov cl, BYTE PTR [ebx]
	xor ebx, ebx
	mov bl, cl
	pop ecx

	mov [edi], bl
	inc esi

	pop ebx
	inc ebx

ShouldWeLoop:							;now check if esi == MAX_NUM_CHAR then {we are done} else {loop again}
	cmp esi, _MAX
	je No
	jmp L1
No:
	ret
PseudoRandEncrypt ENDP

END main