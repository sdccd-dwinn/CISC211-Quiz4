; CISC 211
; Quiz 4
; Dylan Winn 2024-11-13

	global _start

section .text

; function that adds three integers
; 3 arguments on stack: numbers to add
; result in eax: sum
_sum3:
	; equivalent to enter 16,0
	push ebp		; save stack base pointer for later by pushing to stack
	mov ebp, esp		; set stack base pointer to current stack pointer so we can use it for relative addressing
	sub esp, 16		; move stack pointer down 4 dwords to make room for local variables

	mov eax, DWORD[ebp+8]	; load 1st argument from call stack to eax
	mov DWORD[ebp-4], eax;	; store value in 1st local variable (we'll call it lx)

	mov eax, DWORD[ebp+12]	; load 2nd argument from call stack to eax
	mov DWORD[ebp-8], eax;	; store value in 2nd local variable (we'll call it ly)

	mov eax, DWORD[ebp+16]	; load 3rd argument from call stack to eax
	mov DWORD[ebp-12], eax;	; store value in 3rd local variable (we'll call it lz)

	mov eax, DWORD[ebp-4]	; load value from lx
	mov ebx, DWORD[ebp-8]	; load value from ly
	add eax, ebx;		; add them using eax as accumulator
	mov ebx, DWORD[ebp-12]	; load value from lz
	add eax, ebx;		; add them using eax as accumulator

	mov DWORD[ebp-12], eax;	; store value in 4th local variable (we'll call it lresult)

	mov eax, DWORD[ebp-12]	; set return value to value of lresult
	leave			; restore base pointer and stack pointer to their original values
	ret

_start:
	mov eax, [z]		; push function arguments in reverse order
	push eax
	mov eax, [y]
	push eax
	mov eax, [x]
	push eax
	call _sum3		; call function
	mov [result], eax	; store function result in global variable
	add esp, 12		; move stack pointer up 4 dwords to remove arguments pushed earlier

exit:
	mov eax, 1		; syscall exit
	mov ebx, 0		; error_code=0
	int 0x80

section .bss
	result resd 1		; result will be put here

section .data
	x dd 1			; pre-defined numbers to add
	y dd 2
	z dd 3
