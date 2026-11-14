section .data
	i db 0
	j db 0
	c db '@'
	n db 10
	v db ' '

	r2 equ 2304

	fini equ 49
	finj equ 99
	centeri equ 24
	centerj equ 48
section .text

	global _start
	
	print:
		mov rax, 1
		mov rdi, 1
		mov rsi, c
		mov rdx, 1

		syscall

		inc byte [rel j]

		jmp inner_loop
	
	print_n:
		mov rax, 1
		mov rdi, 1
		mov rsi, n
		mov rdx, 1

		syscall

		jmp loop
	

	print_void:
		mov rax, 1
		mov rdi, 1
		mov rsi, v
		mov rdx, 1

		syscall

		inc byte [rel j]

		jmp inner_loop

	_start:


	loop:
		cmp byte [rel i], fini
		jge done

		jmp inner_loop

	inner_loop:
		cmp byte [rel j], finj
		jge end_inner

		mov al, byte [rel i]
		sub al, centeri
		imul al

		imul ax, 4
		
		mov cx, ax
		
		mov al, [rel j]
		sub al, centerj
		imul al

		add cx, ax
		

		cmp cx, r2
		jle print

		jmp print_void

		

	end_inner:

		mov [rel j], 0
		inc byte [rel i]
		jmp print_n
		

	done:
		mov rax, 60
		mov rdi, 0

		syscall
