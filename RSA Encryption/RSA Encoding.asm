INCLUDE Irvine32.inc    
.data
source  BYTE 2
enum DWORD 7
dnum DWORD 3
nnum DWORD 33
.code
main proc
  
	mov ecx, SIZEOF source
	mov esi, 0
	mov eax, 0
	mov ebx, 0
	;L1:
		push ecx
		mov ecx, enum
		dec ecx
		mov al, [source+esi]
		mov bl, [source+esi]
		L2:
			mul ebx
			div nnum
			mov eax, edx
			mov edx, 0
		loop L2
		pop ecx
		call WriteInt
		call CRLF
	;loop L1

	




	invoke ExitProcess,0
main endp
end main
