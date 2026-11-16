section .data
	nb_digits db 0

section .text

   	; Entry point for printing a signed integer.
   	; The number to print must be stored in 'AX' before calling this label.
   	; Supports signed integers in the range [-255, 255].	
    	print_nb: 	
		mov r9b, 10 ; stores 10 at register r9b (used at division)
		cmp ax, 0 ; compares the number to 0
		jl nb_negative ; if less, jump to 'nb_negative'

		jmp store_nb ; else, jump directly to 'stock_nb'
		

   	; Prints all stored digits in reverse extraction order.
  	; Digits are popped from the stack, restoring their original order.
   	; Decrements 'nb_digits' after each printed digit.
        ; Stops when all digits have been printed (nb_digits == 0).	
    	print_digit:
		cmp byte [rel nb_digits], 0 
		jle done 
		
		; Printing the digit
		mov rax, 1
		mov rdi, 1
		mov rsi, rsp
		mov rdx, 1

		syscall

		pop rax ; Removes the top value of the stack

		mov rax, r8 
		
		dec byte [rel nb_digits] ; nb_digits--

		
		jmp print_digit ; Prints the next digit

	; Extracts decimal digits using division by 10.
        ; 'al' receives the quotient, 'ah' receives the remainder (property of 'div').
        ; The remainder is converted to its ASCII representation (with + '0')
        ; and pushed onto the stack.
        ; Repeats until the quotient becomes zero.
	store_nb:
		mov ah, 0
		mov bl, r9b
		div bl	

		mov r8, rax ; Copies the result of division to 'r8'

		push rax ; Pushes the value onto the stack
		mov byte [rsp], ah ; Replaces the lowest byte (8bits) of the pushed value with the remainder
		add byte [rsp], '0' ; Converts the byte to its corresponding ASCII code
		

		; IMPORTANT: [rsp] accesses the first byte (8 bits) at the top of the stack.
		;            [rsp+1] accesses the next bytes.

		inc byte [rel nb_digits] ; nb_digits++

		cmp al, 0 
		je print_digit ; Starts printing when the quotient becomes zero

		jmp store_nb
		
   	; Handles negative integers.
  	; Saves the original value before using the write syscall,
  	; since syscalls overwrite RAX.
 	; Prints the minus sign, then computes the absolute value
 	; before continuing with decimal digit extraction.
	nb_negative:
		mov r12w, ax

		mov r10, '-' ; Minus sign
		push r10 ; Pushes Minus sign to the stack

		mov rax, 1 
		mov rdi, 1
		mov rsi, rsp
		mov rdx, 1

		syscall 

		pop r10 ; Removes the value from the stack

		; Lets explain the following instructions with an example of 'ax' = -15 (so r12w = -15)
		mov cx, r12w ; cx <- -15
		mov r12w, 0 ; r12w <- 0
		sub r12w, cx ; r12w <- r12w - cx ==> r12w <- 0 - (-15) ==> r12w <- 15

		; In binary : 
				; cx <- 1111111111110001
				; r12w <- 0000000000000000
				; r12w <- 0000000000000000 - 1111111111110001 <- 0000000000001111 (15)
		mov ax, r12w ; Restores the absolute value in 'ax'

		jmp store_nb ; Starts stocking the absolute value of the number
	
	; Terminates the program using the exit syscall.
	done:
		mov rax, 60
		mov rdi, 0

		syscall
