TITLE Psuedo Random Number Generator

INCLUDE Irvine32.inc

.data
inputString BYTE "apple"
outputString BYTE "     "
R0 DWORD 30					;whatever TIME is
K DWORD 20					;whatever constant we want
S DWORD 12					;whatever constant we want
MAX_NUM_CHAR DWORD 5		;whatever character count is

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

	;Let's take the next letter from inputString and put it in outputString

	inc esi

ShouldWeLoop:
	
	;now check if esi == MAX_NUM_CHAR then {we are done} else {loop again}

exit
main ENDP
END main