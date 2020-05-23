;************************************************************************************
;* Rewrites interrupt's procedure address with resident programm                    *
;*              finishes with normal 09h                                            *
;************************************************************************************
.model tiny
.386

;____________________________________________________________________________________
VIDEO_MEM equ 0b800h
PLACE_TO_WRITE equ (5 * 80 + 35) * 2
COLOR_C equ 30d
;____________________________________________________________________________________

.code

locals @@

org 100h

start:
	xor ax, ax
	mov es, ax      ; int 09h at 0000:9h * 4 (es := 0000h)

	mov bx, 4d * 09h ; int 09h at es:[bx] 

	cli ; clear interrupt-enable flag (cpu ignores external ints) 
    
	mov ax, word ptr es:[bx] ; mov ptr int 09h to Old09h label
	mov word ptr [Old09h], ax
    
	mov ax, word ptr es:[bx + 2]
	mov word ptr [Old09h + 2], ax

	mov word ptr es:[bx], offset New09
	mov ax, cs
	mov word ptr es:[bx+2], ax

	call draw_frame
	
exit:	
	mov ax, 3100h
	mov bx, offset lbl_to_count_size
	sub bx, offset New09 
	mov dx, bx ; size of memory  to stay rezident
	int 21h

	sti ; interrupt interception finished, set interrupt-enable flag


New09 	proc
	push es di ax

	mov ax, VIDEO_MEM
	mov es, ax

	in al, 60h  ; get scan-code from 60th port

	mov di, PLACE_TO_WRITE + 320d 
	mov ah, COLOR_C
	
	cld
	stosw

	pop ax di es

	db 0eah		; op_code for jmp far
Old09h 	dw 0            ; here will be setted address of int 09h to run
	dw 0
	
	iret
New09	endp

lbl_to_count_size:

include FRAME.ASM

end Start