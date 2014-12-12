TITLE Encryption UI (Encrypt_UI.asm)
; Description:
; Revision Date:

INCLUDE Irvine32.inc

.data

BUFFER = 15000					; Buffer for input file. Large enough to prevent overflow

COMMENT !
---------------------------------
Error messages for openning file
and reading the file.
---------------------------------
!

inputError	BYTE "Error: File did not open!", 0
readinError BYTE "Error: Cannot read from file!", 0
writeError	BYTE "Error: Cannot write to file!", 0


COMMENT &
---------------------------------
Prompt for decrypt or encrypt
Prompt for encryption keys.
Separate n, e and d values
---------------------------------
&
cPrompt		BYTE "Enter (0) for Encryption or (1) for Decryption: ", 0
nPrompt		BYTE "Enter n value of the key: ", 0
multPrompt	BYTE "Enter value for multiplier/counter: ", 0
ePrompt	BYTE "Enter e value of the key: ", 0
dPrompt	BYTE "Enter d value of the key: ", 0				;prompt only when decrypting(could be avoided if we store encrytion key values in a file)
fileLengthMsg BYTE "Message Length: ", 0
newLengthPrompt BYTE "New Message Length: ", 0


choice		BYTE ?

COMMENT %
---------------------------------
Store public and private key for
encryption.
---------------------------------
%

nValue		DWORD ?
encryptKey	DWORD ?
decryptKey	DWORD ?


COMMENT $
---------------------------------
Allocated memory for the input
file portion of the program
---------------------------------
$

inFilePrompt	BYTE "Enter the input file name: ", 0
iBuffer			BYTE 30 DUP(?)
iByteCount		DWORD ?
inFileName		DWORD ?
fileHandle		DWORD ?

COMMENT &
---------------------------------
Allocated memory for the output
file portion of the program
---------------------------------
&

outFilePrompt	BYTE "Enter desired output file name: ", 0
oBuffer			BYTE 30 DUP(?)
outFilename		DWORD ?

COMMENT !
--------------------------------
Allocated memory for input file
data and data manipulation for
encryption
--------------------------------
!

fileData	BYTE	BUFFER DUP(?)
EFileData	DWORD	BUFFER DUP(?)
align		DWORD
manipData	BYTE	BUFFER DUP(?)
align		DWORD
EncryptedByte DWORD ?


COMMENT $
---------------------------------
Values for Random Generator
---------------------------------
$
T DWORD ?
K DWORD ?
R0 DWORD ?

.code
main PROC

COMMENT %
---------------------------------------
Prompt the user for either encryption
or decryption.
---------------------------------------
%

Initial:
mov edx, OFFSET cPrompt
call WriteString
call ReadInt
cmp eax, 1


je Decrypt
COMMENT $
--------------------------------------
Prompt the user for n value of the key
and e value of the key
--------------------------------------
$
call Clrscr
mov edx, OFFSET nPrompt
call WriteString
call ReadInt
mov nValue, eax

mov edx, OFFSET ePrompt
call WriteString
call ReadInt
mov encryptKey, eax

COMMENT &
------------------------------------
Prompt user for the input file name
and store the file name
------------------------------------
&
call Clrscr
mov edx, OFFSET inFilePrompt
call WriteString
mov edx, OFFSET iBuffer
mov ecx, SIZEOF iBuffer
call ReadString
mov iByteCount, eax
mov inFileName, edx

COMMENT !
------------------------------------
Prompt user for the output file name
and store the file name
------------------------------------
!

mov edx, OFFSET outFilePrompt
call WriteString
mov edx, OFFSET oBuffer
mov ecx, SIZEOF oBuffer
call ReadString
mov iByteCount, eax
mov outFilename, edx

COMMENT %
-------------------------------------
Open user define file input
-------------------------------------
%

mov edx, inFileName
call OpenInputFile
cmp eax, INVALID_HANDLE_VALUE
je OpenFileError
mov fileHandle, eax

COMMENT $
------------------------------------
Read from file
------------------------------------
$

mov eax, fileHandle
mov edx, OFFSET fileData
mov ecx, BUFFER
call ReadFromFile
jc	file_readError
mov iByteCount, eax

mov eax, fileHandle
call CloseFile


COMMENT &
-------------------------------------
call Encryption PROC here
-------------------------------------
&
call Clrscr
	
	mov edx, OFFSET fileLengthMsg
	call WriteString
	mov eax, iByteCount
	call WriteInt
	call Crlf
	mov edx, OFFSET newLengthPrompt
	call WriteString
	call ReadInt
	mov iByteCount, eax
	dec eax
	mov R0, eax
	mov edx, OFFSET multPrompt
	call WriteString
	call ReadInt
	mov K, eax
	mov T, eax

	push T						; counter
	push iByteCount
	push OFFSET fileData
	push R0						; seed
	push OFFSET manipData
	push K						; multiplier

	call PseudoRandEncrypt

COMMENT !
------------------------------------
Create file and write to file
------------------------------------
!


mov edx, OFFSET oBuffer
call CreateOutputFile
mov fileHandle, eax

mov ecx, iByteCount

EncryptionLoop:
	push ecx
	mov eax, 0
	mov al, [manipData+esi]
	mov ecx, encryptKey
	mov ebx, nValue
	push esi
	call Encryption
	pop esi
	mov EncryptedByte, eax
	call WriteInt
	mov eax, fileHandle
	mov ecx, 4
	mov edx, OFFSET EncryptedByte
	call WriteToFile
	inc esi
	pop ecx
loop EncryptionLoop

jc writeFalse_Error
mov iByteCount, eax

mov eax, fileHandle
call CloseFile

exit




Decrypt:
call Clrscr
mov edx, OFFSET nPrompt
call WriteString
call ReadInt
mov nValue, eax

mov edx, OFFSET dPrompt
call WriteString
call ReadInt
mov decryptKey, eax

COMMENT &
------------------------------------
Prompt user for the input file name
and store the file name
------------------------------------
&
call Clrscr

mov edx, OFFSET inFilePrompt
call WriteString
mov edx, OFFSET iBuffer
mov ecx, SIZEOF iBuffer
call ReadString
mov iByteCount, eax
mov inFileName, edx

COMMENT !
------------------------------------
Prompt user for the output file name
and store the file name
------------------------------------
!

mov edx, OFFSET outFilePrompt
call WriteString
mov edx, OFFSET oBuffer
mov ecx, SIZEOF oBuffer
call ReadString
mov iByteCount, eax
mov outFilename, edx

COMMENT %
-------------------------------------
Open user define file input
-------------------------------------
%

mov edx, inFileName
call OpenInputFile
cmp eax, INVALID_HANDLE_VALUE
je OpenFileError
mov fileHandle, eax

COMMENT $
------------------------------------
Read from file
------------------------------------
$

mov eax, fileHandle
mov edx, OFFSET EFileData
mov ecx, BUFFER
call ReadFromFile
jc	file_readError
mov edx, 0
mov ebx, 4
div ebx
mov iByteCount, eax

mov eax, fileHandle
call CloseFile

COMMENT &
-------------------------------------
call Decryption PROC here
-------------------------------------
&
call Clrscr

	mov ecx, iByteCount
	mov esi, 0
	DecryptDataLoop:
		push ecx
		mov eax, esi
		mov ebx, 4
		mul ebx
		mov ebx, [EFileData+eax]
		mov eax, ebx

		mov ebx, nValue
		mov ecx, decryptKey
		push esi
		call Encryption
		pop esi
		mov [fileData+esi], al

		inc esi
		pop ecx
	loop DecryptDataloop

	mov edx, OFFSET fileLengthMsg
	call WriteString
	mov eax, iByteCount
	call WriteInt
	call Crlf
	mov edx, OFFSET newLengthPrompt
	call WriteString
	call ReadInt
	mov iByteCount, eax
	dec eax
	mov R0, eax
	mov edx, OFFSET multPrompt
	call WriteString
	call ReadInt
	mov K, eax
	mov T, eax

	push T						; counter
	push iByteCount
	push OFFSET fileData
	push R0						; seed
	push OFFSET manipData
	push K						; multiplier

	call PseudoRandDecrypt

COMMENT !
------------------------------------
Create file and write to file
------------------------------------
!

mov edx, OFFSET oBuffer
call CreateOutputFile
mov fileHandle, eax
mov edx, OFFSET manipData
mov ecx, iByteCount
call WriteToFile
jc writeFalse_Error
mov iByteCount, eax

mov eax, fileHandle
call CloseFile

exit


OpenFileError:
	mov edx, OFFSET inputError
	call WriteString
	call Crlf
	jmp Initial							; goes to the beginning of the program

file_readError:
	mov edx, OFFSET readinError
	call WriteString
	call Crlf
	jmp Initial							; goes to the beginning of the program

writeFalse_Error:
	mov edx, OFFSET writeError
	call WriteString
	call Crlf
	jmp Initial

main ENDP

COMMENT !
-----------------------------
Encrytion procedure
-----------------------------
!

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

	;test edx, 110					;test with " " which is 20h which is 00100000b
	;jnz ShouldWeLoop					;lets jump if there is something other than an empty space

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

Encryption PROC
	dec ecx
	mov esi, eax
	encryptIt:
		mul esi
		div ebx
		mov eax, edx
		mov edx, 0
	loop encryptIt
	ret

Encryption ENDP


COMMENT %
-----------------------------
Decryption procedure
-----------------------------
%

;--------------------------------------------------------------------------------
PseudoRandDecrypt PROC USES esi, _K:DWORD, _output:DWORD, _R0:DWORD, _input:DWORD, _MAX:DWORD, _T:DWORD
;Generates random integers between 0 and (MAX_NUM_CHAR - 1) & decrypts a string.
;Recieves: _K: K constant, _output: OFFSET outputString, _R0: Seed
;		   _input: OFFSET inputString, _MAX: Max number of characters, _T: T constant
;Returns:
;--------------------------------------------------------------------------------
	xor esi, esi				;esi = 0

	mov eax, _R0
	mov ebx, _output
	mov ecx, _input

L1:
	mov edx, _K
	mov edi, _T

	mul edx						;edx:eax = R(0) * K
	add eax, edi				;edx:eax = (R(0) * K) + T
	div _MAX					;edx = ((R(0) * K) + T) % MAX_NUM_CHAR which is R(n)
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

Decryption PROC
	dec ecx
	mov esi, eax
	decryptLoop:
		mul esi
		div ebx
		mov eax, edx
		mov edx, 0
	loop decryptLoop
	ret
Decryption ENDP

END main