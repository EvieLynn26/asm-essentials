SYS_WRITE equ 4
STDOUT equ 1
EXIT_CODE equ 1
ERROR_CODE equ 0

MAX_NUM_LEN equ 10d


section .data

        test_char	db	'f'
        test_str	db	"love", 0 	  
        test_int    db	123			   
        test_hex	db	0xff

       	;format_str	db	10, "my_str = %s", 10, "my_char = %c", 10, "my_int = %d", 10, "my_hex = %h", 10, 0
		format_str db 10, "%d", 10, 0

        output_buff times 200h db 0
		buff_for_num times MAX_NUM_LEN db '0'

		check_buff db "ah != 0", 0

    
section .text

global  _start

; Using cdecl calling convention

;*done_b
_start:
        ;push	test_hex
        push	test_int
        ;push	test_char
        ;push 	test_str
        push 	format_str

        call 	my_printf
	
        add esp, 20    ; args_num * 4(bytes)

        mov eax, EXIT_CODE      ; sys_exit
        mov esi, ERROR_CODE

        int 0x80
;*done_e

; esi, edx, eax

my_printf:
        push ebp    
        mov	 ebp, esp    ; to access args by offset in stack

        ; format_str at ebp + 8  stack: <--|saved ebp|ret addr|format_str|arg1|...
        mov	esi, dword[ebp + 8]
		add ebp, 12d     ; set ebp on the first arg
        xor	edx, edx    ; edx -- offset in stack
        xor	edi, edi    ; edi -- offset in destination (output_buffer)

loop_start:
		xor eax, eax				 ; eax uses in jump_table
        mov	 al, byte[esi]           ; curr_byte in al 
        cmp	 al, 0                   ; check str_end
        je	str_end

		; str continues => look for '%'
		cmp	al, '%'
		jne	to_copy  		; if not an arg, copy letters

        ; parse '%' and arg
		inc	esi     		; skip '%'
		mov	al, byte[esi] 	; curr_byte (next to '%') in al
		
		cmp	al, '%'
		je	to_copy 		;print '%'

		;parse arg -->

		;mov ecx, [parse_char_arg]
		;add ecx, eax
		;sub ecx, 'b'		; table starts from 'b' -> 0

		inc esi
		jmp parse_dec_arg

.jump_table:
		jmp parse_bin_arg 	;ascii 'b' (= 66d - 66d) -> 0
		jmp parse_char_arg	;'c' -> 1
		jmp parse_dec_arg	;'d' -> 2
		nop 		;3
		nop 		;3
		nop 		;3
		nop 		;3
		nop 		;3
		nop 		;3
		nop 		;3
		nop 		;3
		nop 		;3
		jmp parse_oct_arg   ;ascii 'o' (= 79d - 66d) -> 13
		jmp loop_start 		;14
		jmp loop_start 		;15
		jmp loop_start 		;16
		jmp parse_str_arg 		;ascii 's' (= 83d - 66d) -> 17
		jmp loop_start 		;18
		jmp loop_start 		;19
		jmp loop_start 		;20
		jmp loop_start 		;21
		jmp parse_hex_arg 		;ascii 'x' (= 88d - 66d) -> 22


parse_char_arg:
        mov	ecx, dword[ebp + edx * 4] 
        mov	 al,  byte[ecx]             
        mov	byte[output_buff + edi], al					
        inc	edi
		inc esi
        inc	edx	
		jmp	loop_start	

		
;*********************************************************************	
;*  Takes string's address from stack and add to output_buffer       *
;*  copy_str: 														 *
;*		sourse_str at ecx											 *
;*********************************************************************	
parse_str_arg:				
		mov	ecx, dword[ebp + edx * 4] ; in ecx -- offset string to add

.copy_str:
		mov	al, byte[ecx]			
		cmp	al, 0
		je	.str_arg_end

		mov	byte[output_buff + edi], al
		inc	ecx
		inc	edi
		jmp	.copy_str

.str_arg_end:
		inc esi                       ; skip ;'s' after '%'
		inc	edx						  ; skip arg in stack 
		jmp	loop_start         


parse_bin_arg:
		mov	byte[output_buff + edi], '0'
		inc	edi
		mov	byte[output_buff + edi], 'b'
		inc	edi

		mov bl, 2d
		jmp loop_start;convert_num_write


parse_oct_arg:
		mov	byte[output_buff + edi], '0'
		inc	edi
		mov	byte[output_buff + edi], 'o'
		inc	edi

		mov bl, 8d
		jmp convert_num_write


parse_dec_arg:
		mov	bl, 10d
		jmp convert_num_write


parse_hex_arg:
		mov	byte[output_buff + edi], '0'
		inc	edi
		mov	byte[output_buff + edi], 'x'
		inc	edi

		mov bl, 16d
		jmp convert_num_write


;*********************************************************************	
;*          Converst arg from stack to the number system             *
;*                   and puts into buff_for_num                      *
;* 													                 *
;*	 ebx = base of the number system                                 *
;*								                                     *
;*                    All registers reserved.                        *         
;*********************************************************************
convert_num_write:
		;pusha
		push esi

		xor ax, ax

		mov	ecx, dword[ebp + edx * 4]
		mov	 al,  byte[ecx]				;num_to_convert in eax

		cmp al, 123
		je check

		mov esi, buff_for_num
		add esi, MAX_NUM_LEN
		dec esi

		mov byte[esi], 0
		dec esi

.get_digits: 
		xor ah, ah				    ; zero the remainder
		cmp ax, 0
		je .num_end					; if no more digits to print

		div bl
		
		add ah, '0' 
		cmp ah, '9'
		jbe .print_digit 					; if [0..9] digit
		add ah, 'A' - '0' - 10d     ; if [A..F]

.print_digit:		
		mov byte[esi], ah			; put a digit to buff
		;cmp ah, 0
		;jne str_end
		dec esi
		jmp .get_digits

.num_end: 							; if no more digits to print
				
		;mov al, '0'							
		;cmp byte[ecx], al
		;jne 
				; skip '0' at the beg 
		;je .zero


.copy_str:
		;popa
		mov ecx, buff_for_num
		mov	 al, byte[ecx]			
		cmp	 al, 0
		je	.end

		mov	byte[output_buff + edi], al
		inc	ecx
		inc	edi
		jmp	.copy_str

.end:   
		pop esi

		inc edx						; "eat" arg in stack
		jmp loop_start				; print arg finished


;*************************************************************************		
to_copy:
		mov	byte[output_buff + edi], al ; add al symbol to output_buff
		inc	edi
		inc	esi

	    jmp	loop_start


str_end:
		mov	byte[output_buff + edi], 0 ; add '\0' to output string
		inc	edi 	

		;syscall for writing output_buff
		mov	edx, edi
		mov	eax, SYS_WRITE
		mov	esi, STDOUT
		mov	ecx, output_buff

		int	0x80

		pop	ebp

		ret


check:	
		;syscall for writing check_buff
		mov	edx, 10
		mov	eax, SYS_WRITE
		mov	esi, STDOUT
		mov	ecx, check_buff

		int	0x80

		pop esi
		pop ebp 
		ret
