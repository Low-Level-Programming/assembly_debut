# assembly_debut

## Description
A place to explore the fundamentals of x86-64 Assembly, as a first step to learn how computers work and executes instruction.
We'll explore how cpu and linux executes operations, registers, memory, data representation, and many more. 
The goal is to master assembly and be able to debug and write code using it, and eventually build the skills needed for reverse engineering.

## What we've built so far
- **rectangle.asm** : Draws the outline of a rectangle
- **circle.asm** : Draws a full circle
- **print_numbers.asm** : Contains a procedure that prints signed and unsigned integers to the terminal

## Indivdual progress

### Ali :
#### What I've learned so far
##### Day 0 (before assembly)
- Differentes number-base representations (binary, decimal, hexadecimal, octal).
- Number-base conversions.
- Negative integers representation.
- Computer architecture basics (registers, cpu, ram).
- Binary arithmetic (addition, substraction).
- Bitwise operations (AND, OR, XOR, NAND, NOT, bit shifting).

##### Day 1
- Printing a buffer 
- Defining data using NASM directives : `db`, `dw`, `equ`
- Storing data in registers
- Arithmetic operations : `add`, `mul`, `sub`
- Creating loops (regular and nested loops)
- Comparing values using `cmp`
- Conditionnal and unconditionnal jumps : `jge`, `jle`, `jg`, `jl`, `je`, `jmp` 
- Understanding registers sizes
- Using labels to define data and code locations
- Understanding low-level program execution and how the CPU processes instructions

##### Day 2
- Integer divisions: `div bl` (al <- ax / bl AND ah <- ax % bl)
- Inter to ASCII conversion
- Printing signed and unsigned integers
- Using `call` and `ret`


## Resources :
### BOOKS :
- [x86-64 Assembly Language Programming with Ubuntu (PDF)](Resources/Assembly.pdf)
    - Author : Ed Jorgensen
    - License: CC BY-NC-SA 4.0

### LINKS :
- [NASM documentation](https://www.nasm.us/doc/)
- [NASM tutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial/)

## How to Run 
### Prerequisites
- A Linux machine
- NASM
- GNU Linker (`ld`)

### Install NASM
- On Ubuntu/Debian :
```
sudo apt install nasm
```

- On Arch Linux :
```
sudo pacman -S nasm
```

### Install GNU Binutils (ld)
- On Ubuntu/Debian :
```
sudo apt install binutils
```

- On Arch Linux :
```
sudo pacman -S binutils
```

### Assemble
```
nasm -f elf64 file.asm -o file.o
```

### Link
```
ld file.o -o file
```

### Run
```
./file
```
