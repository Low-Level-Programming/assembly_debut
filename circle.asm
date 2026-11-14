; Draws a circle using the mathematical equation : 
;        (x-cx)² + (y-cy)² <= r²  (1)
;
; where :
;         - (x, y) : the coordinates of the current character position
;         - (cx, cy) : the coordinates of the center
;	  - r : the radius
;
; The problem : Terminal characters are approximatly twice as tall as they are wide
; The solution : Expand the circle horizontally by a factor of 2
; Method : Verify the current position belongs to the original circle
; Equation : ((x/2) - cx)² + (y - cy)² <= r²
;
; Why x/2 ? :
;       Let 'xa' be the initial x-coordinate of a position in the circle, and 'xn' the new x-coordinates (after expansion).
;	To expand it by a factor of 2, 'xa' need to be multiplied by that factor.
;	Wich leads us to : xn = 2xa  (2)
;
;	We need to verify that 'xa' lies the original circle (because we need to determine if the new position
;	corresponds to a position inside the original circle).
;
;	The equation (1) becomes (xa - cx)² + (y - cy)² <= r² 
;	(Note : y-coordinates remains unchanged because we're expanding the circle horizontally)
;	
;	But we're not given 'xa', we only have the new coordinates in our grid.
;	So, using equation (2) : xa = xn / 2
;
;	Which leads us to :  ((xn/2) - cx)² + (y - cy)² <= r²  -> (((xn - 2cx) / 2)² + (y - cy)² <= r² 
;							       -> ((xn - 2cx)² / 4) + (y - cy)² <= r²
;
;
; Finally, to avoid division, we multiply by 4 :
;
;	(xn - 2cx)² + 4(y - cy)² <= 4r²

section .data
	y db 0  ; stores byte 0
	x db 0 ; stores byte 0
	c db '.' ; stores ASCII '@' in a byte
	n db 10 ; newline char
	v db ' ' ; space char


	r2 equ 2304 ; #define r2 2304
	finy equ 49 
	finx equ 99
	centery equ 24
	centerx equ 48

section .text

	global _start
	
	print: ; Prints the character stored at memory address 'c' to terminal
		mov rax, 1
		mov rdi, 1
		mov rsi, c
		mov rdx, 1

		syscall

		inc byte [rel x] ; x++

		jmp inner_loop ; go to inner_loop
	
	print_n: ; prints a newline character
		mov rax, 1
		mov rdi, 1
		mov rsi, n
		mov rdx, 1

		syscall

		jmp loop ; go to loop
	

	print_void: ; prints space
		mov rax, 1
		mov rdi, 1
		mov rsi, v
		mov rdx, 1

		syscall

		inc byte [rel x] ; x++

		jmp inner_loop ; go to inner_loop

	_start: ; program starts here


	loop: ; outer loop (rows)
		cmp byte [rel y], finy ; compare the byte stored at memory address 'y' to 'finy'(49)
		jge done ; if greater or equals, go to label done

		jmp inner_loop ; go to inner_loop

	inner_loop: ; inner loop (columns)
		cmp byte [rel x], finx
		jge end_inner

		; y-coordinate

		mov al, byte [rel y] ; stores the byte stored at address 'y' (vertical position) to register al (8 bits)
		sub al, centery ; al <- al - centery (al <- y - centery)
		imul al ; ax <- al * al (ax <- (y - centery)²) / ax is 16 bits

		imul ax, 4 ; ax <- ax * 4 (ax <- 4(y - centery)²)
		
		; store result at register cx
		mov cx, ax ; cx <- ax (cx <- 4(y - centery)²)
		
		; x-coordinate

		mov al, byte [rel x] ; al <- x (al had been overwritten)
		sub al, centerx ; al <- al - centerx (al <- x - centerx)
		imul al ; ax <- al * al (ax <- (x - centerx)²) (ax had been overwritten)

		; add result to value stored at register cx, which is 4(y - centery)²
		add cx, ax ; cx <- cx + ax (cx <- 4(y - centery)² + (x - centerx)²)
		
		; now we compare cx with r², to apply our mathematical equation
		cmp cx, r2
		jle print ; go to print if less or equals

		jmp print_void ; prints a space if cx is greater than r²

		

	end_inner:
		mov [rel x], 0 ; resets x to its inital value (returns to first column)
		inc byte [rel y] ; y++ (next row)
		jmp print_n ; newline
		

	done:
		mov rax, 60
		mov rdi, 0

		syscall
