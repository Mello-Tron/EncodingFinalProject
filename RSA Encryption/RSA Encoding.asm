INCLUDE Irvine32.inc    
.data
source BYTE "abcdefgh",0
enum DWORD 3
dnum DWORD 151143427
nnum DWORD 226745257
.code
main proc
  
	mov ecx, SIZEOF source
	dec ecx
	mov esi, 0
	
	L1:
		mov eax, 0
		mov ebx, 0
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
		
		call WriteInt
		call CRLF


		mov ecx, dnum
		dec ecx
		mov ebx, eax
		L3:
			mul ebx
			div nnum
			mov eax, edx
			mov edx, 0
		loop L3
				
		call WriteChar
		call CRLF


		pop ecx
		inc esi
	loop L1

	




	invoke ExitProcess,0
main endp
end main
