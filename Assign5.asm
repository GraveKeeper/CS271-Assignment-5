; Assignment 5     (Assignment5.asm)

; Author(s): Sean Harrington
; CS_271 / Project ID                 Date: 3/5/2023

; Description: 
; Introduce the program. 
; Get a user request in the range [min = 10 .. max = 200]. 
; Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elements of an array. 
; Display the list of integers before sorting, 10 numbers per line. 
; Sort the list in descending order (i.e., largest first). 
; Calculate and display the median value, rounded to the nearest integer. Any number resulting in .5 should round up.
; Display the sorted list, 10 numbers per line. 

INCLUDE Irvine32.inc

; (insert constant definitions here)
.386
.stack 4096			;SS register
ExitProcess proto,dwExitCode:dword


.const
	MAX_IN					equ 200
	MIN_IN					equ	10

	MAX_NUM					equ 999
	MIN_NUM					equ 100

	MAX_RAN					equ 1024
	MIN_RAN					equ 64


.data			

;Procedures and Strings

	strIntro				BYTE				"Assignment 5 - Arrays - Sean Harrington", 10, 13, 10, 13
							BYTE				"Please enter the number of integers you would like to generate.",10,13
							BYTE				"Acceptable Integers are within the set [10, 200]: ", 0

	strRError				BYTE				"Error: The input given is not valid please enter a value within the given range.", 0

	strUnsort				BYTE				10, 13, "The Unsorted Array", 10, 13, 0
	strSort					BYTE				10, 13, "The Sorted Array", 10, 13, 0
	strbye					BYTE				10, 13, 10, 13, "Goodbye, Thanks for using", 10, 13, 0
	strMed					BYTE				10, 13, 10, 13, "The Median Value: ", 0


	intArray				DWORD				200 DUP (0)
	intUserIn				DWORD				?

.code
introAndBye PROC
	push ebp
	mov ebp, esp
	mov edx, [ebp+8]
	call WriteString
	pop ebp
	ret 4

introAndBye ENDP



getData PROC
	push ebp
	mov ebp, esp
	mov ebx, [ebp + 8]
	mov edx, [ebp + 12]

checkStart:
	call ReadDec
	cmp eax, MAX_IN
	ja errorIn
	cmp eax, MIN_IN
	jb errorIn

	mov [ebx], eax
	pop ebp
	ret 8

errorIn:
	call WriteString
	jmp checkStart

getData ENDP



fillArray PROC
	push ebp
	mov ebp, esp
	mov esi, [ebp + 8]
	mov ecx, [ebp + 12]
	mov ebx,MAX_RAN
	sub ebx, MIN_RAN
	add ebx, 1
	L1:
		mov eax, ebx
		call RandomRange
		add eax, MIN_RAN
		mov [esi], eax
		add esi, 4

	loop L1
	pop ebp
	ret 8

fillArray ENDP


displayMedian PROC
	push ebp
	mov ebp, esp
	mov edx, [esp + 16]
	call WriteString

	mov ebx, 2
	mov esi, [ebp + 12]
	mov eax, [ebp + 8]
	cdq
	div ebx
	mov ecx, eax

	L1:
		add esi, 4
		loop L1

		mov eax, [esi]
		cmp edx, 1
		je funcEnd

		add eax, [esi - 4]
		cdq
		div ebx
		cmp edx, 0
		je funcEnd

		inc eax

funcEnd:
	call WriteDec
	pop ebp
	ret 12

displayMedian ENDP



;displayList {parameters: array (reference), request (value), title (reference)} 
DisplayList PROC
	push ebp
	mov ebp,esp

	mov edx, [ebp + 8]
	call WriteString

	mov ecx, [ebp + 12]
	mov esi, [ebp + 16]
	mov ebx, 0

	L1:
		mov eax, [esi]
		call WriteDec

		push eax
		mov eax, 9
		call WriteChar
		pop eax
		add esi, 4
		inc ebx
		cmp ebx, 5
		je newLine
		return:
	
	loop L1
	jmp funcEnd

newLine:
	call Crlf
	mov ebx, 0
	jmp return

funcEnd:
	pop ebp
	ret 12

DisplayList ENDP


SortList PROC
	push ebp
	mov ebp, esp
	L2:
		mov ecx, [ebp + 8]
		dec ecx
		mov esi, [ebp + 12]
		L1:

		mov eax, [esi]
		mov ebx, [esi + 4]
		cmp eax, ebx
		jae noSwap

		mov [esi], ebx
		mov [esi + 4], eax
		jmp L2
		noSwap:
		add esi, 4
	loop L1

funcEnd:
	pop ebp
	ret 8

SortList ENDP



main PROC
		FINIT

		call Randomize

		push OFFSET strIntro
		call introAndBye

		push OFFSET strRError
		push OFFSET intUserIn
		call getData

		push intUserIn
		push OFFSET intArray
		call fillArray

		push OFFSET intArray
		push intUserIn
		push OFFSET strUnsort
		call displayList

		push OFFSET intArray
		Push IntUserIn
		call sortList

		push OFFSET strMed
		push OFFSET intArray
		push intUserIn
		call displayMedian

		push OFFSET intArray
		push intUserIn
		push OFFSET strSort
		call displayList

		push OFFSET strBye
		call introAndBye


; (insert executable instructions here)
	invoke ExitProcess,0
	exit	; exit to operating system
main ENDP


; (insert additional procedures here)

END main
