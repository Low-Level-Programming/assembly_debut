; new info: 
; []: accesses the memory addess (for write or read) (* in C)
; rel: Access memory relative to RIP (instead of using absolute memory address) 
section .data
	i db '0' ; stored as 48
	j db '0' ; stored as 48
	n db 10 ; newline
	c db '*' ; char to print for outline
	v db ' ' ; char to print 

section .text

	global _start

	print: ;prints the character which the byte is stored at 'c'

		mov rax, 1 ; write
		mov rdi, 1 ; stdout
		mov rsi, c ; start at address 'c'
		mov rdx, 1 ; one byte

		syscall ; Linux ! do it
		jmp inner_loop ; go to label inner_loop
	
	print_n: ; prints a newline character (\n)
		mov rax, 1
		mov rdi, 1
		mov rsi, n
		mov rdx, 1
		syscall

		jmp loop

	print_void: ; print a space
		mov rax, 1
		mov rdi, 1
		mov rsi, v
		mov rdx, 1
		syscall

		jmp inner_loop

	_start: ; start here

	loop: ; our loop
	
		cmp byte [rel i], '9' ; compare the byte stored at address i with the ASCII '9'
		jge done ; if equals or greater, jump to label 'done'

		jmp inner_loop ; go to 'inner loop' (for j)

	inner_loop: ; for j
		inc byte [rel j]
		cmp byte [rel j], '9' ; compare the byte in address j to the ASCII '9'
		jge end_inner ; if equals or greater, jump to 'end_inner' label

		cmp byte [rel j], '1' ; compares the value in address j to ASCII '1'
		je print ; if strictly equals, go to print

		cmp byte [rel j], '8'
		je print

		cmp byte [rel i], '0'
		je print

		cmp byte [rel i], '8'
		je print

		jmp print_void

	end_inner: ; the end of the inner loop
		mov byte [rel j], '0' ; store '0' (48 dec) in address j
		inc byte [rel i] ; i++
		jmp print_n ; printf
	
	done: ; our loop is finished !

		mov rax, 60 ; exit
		mov rdi, 0 ; status

		syscall ; Linux DO IT
