;************************************************************************************
;* Rewrites interrupt's procedure address with resident programm                    *
;*              finishes with normal 09h                                            *
;************************************************************************************
.model tiny
.386

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
	
	
	mov ax, 3100h
	mov dx, 200d ;offset end start - offset New09 proc   ; size of memory  to stay rezident
	int 21h

	sti ; interrupt interception finished, set interrupt-enable flag

New09 proc
	push ax di es


	mov ax, 0b800H
	mov es, ax

	in al, 60H

	mov di, (5*80+40)*2
	mov ah, 4eH
	
	cld
	stosw

	pop es di ax

	db 0eaH		; op_code for jmp far
Old09h 	dw 0            ; here will be setted address of int 09h to run
	dw 0
	
	iret
	endp

end Start