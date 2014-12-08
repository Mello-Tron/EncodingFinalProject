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
ePrompt	BYTE "Enter e value of the key: ", 0
dPrompt	BYTE "Enter d value of the key: ", 0				;prompt only when decrypting(could be avoided if we store encrytion key values in a file)

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
align		DWORD
manipData	BYTE	BUFFER DUP(?)
align		DWORD

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
mov edx, OFFSET choice
call ReadInt
cmp edx, 1
je Decrypt

COMMENT $
--------------------------------------
Prompt the user for n value of the key
and e value of the key
--------------------------------------
$

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


COMMENT !
------------------------------------
Create file and write to file
------------------------------------
!

mov edx, OFFSET oBuffer
call CreateOutputFile
mov fileHandle, eax
mov edx, OFFSET manipData
mov ecx, BUFFER
call WriteToFile
jc writeFalse_Error
mov iByteCount, eax

mov eax, fileHandle
call CloseFile

exit




Decrypt:

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

mov edx, OFFSET inFilePrompt
call WriteString
mov edx, OFFSET iBuffer
mov ecx, SIZEOF iBuffer
call ReadString
mov iByteCount, eax
mov ebx, edx
mov inFileName, ebx

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
mov ebx, edx
mov outFilename, ebx

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

COMMENT &
-------------------------------------
call Decryption PROC here
-------------------------------------
&

COMMENT !
------------------------------------
Create file and write to file
------------------------------------
!

mov edx, OFFSET outFilename
call CreateOutputFile
mov fileHandle, eax
mov edx, OFFSET manipData
mov ecx, BUFFER
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

Encryption PROC

Encryption ENDP


COMMENT %
-----------------------------
Decryption procedure
-----------------------------
%

Decryption PROC

Decryption ENDP

END main