TITLE Psuedo Random Number Generator & Decryption

INCLUDE Irvine32.inc
							;R(n) = ((R(0) * K) + S) % MAX_NUM_CHAR
.data
inputString BYTE "p&peeaipl"
outputString BYTE "         "
R0 DWORD 4					;0 =< R(0) < MAX_NUM_CHAR
K DWORD 4					;0 < K < MAX_NUM_CHAR			K-1 is divisble by all prime factors of MAX_NUM_CHAR, K-1 is multiple of 4, if MAX_NUM_CHAR is a multiple of 4
S DWORD 7					;0 =< S < MAX_NUM_CHAR			MAX_NUM_CHAR and S are coprime
MAX_NUM_CHAR DWORD 9		;whatever character count is

.code
main PROC

	push S
	push MAX_NUM_CHAR
	push OFFSET inputString
	push R0
	push OFFSET outputString
	push K

	call PseudoRandDecrypt

exit
main ENDP

;--------------------------------------------------------------------------------
PseudoRandDecrypt PROC USES esi, _K:DWORD, _output:DWORD, _R0:DWORD, _input:DWORD, _MAX:DWORD, _S:DWORD
;Generates random integers between 0 and (MAX_NUM_CHAR - 1) & decrypts a string.
;Recieves: _K: K constant, _output: OFFSET outputString, _R0: Seed
;		   _input: OFFSET inputString, _MAX: Max number of characters, _S: S constant
;Returns:
;--------------------------------------------------------------------------------
	xor esi, esi				;esi = 0

	mov eax, _R0
	mov ebx, _output
	mov ecx, _input

L1:
	mov edx, _K
	mov edi, _S

	mul edx						;edx:eax = R(0) * K
	add eax, edi				;edx:eax = (R(0) * K) + S
	div _MAX					;edx = ((R(0) * K) + S) % MAX_NUM_CHAR which is R(n)
	mov eax, edx				;eax = "...see above..."

	mov edi, ecx						;edi = OFFSET inputString
	add edi, eax						;edi = OFFSET inputString + R(n)

	push ecx							;Let's take the next letter from inputString and put it in outputString
	xor ecx, ecx
	mov cl, BYTE PTR [edi]

	mov [ebx], cl
	inc esi
	inc ebx

	pop ecx

ShouldWeLoop:							;now check if esi == MAX_NUM_CHAR then {we are done} else {loop again}
	cmp esi, _MAX
	je No
	jmp L1
No:
	ret
PseudoRandDecrypt ENDP

END main