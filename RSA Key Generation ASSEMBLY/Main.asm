TITLE RSA Key Generation

INCLUDE Irvine32.inc

.data

.code
main PROC
    xor eax, eax
	xor ecx, ecx
	xor edx, edx

	mov eax, 2
	push eax
	inc ecx

	mov eax, 3
	push eax
	inc ecx

	add eax, 2	;next Number to try
	push ecx
L1:
	push eax
	xor edx, edx
	mov ebx, ecx
	add ebx, esp
	div ebx
	cmp edx, 0

	pop eax
	loop L1
	pop ecx
	
exit
main ENDP
END main