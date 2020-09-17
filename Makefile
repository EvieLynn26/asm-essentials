all:
	nasm -felf my_printf.asm -g
	ld -melf_i386 -s my_printf.o -o my_printf
