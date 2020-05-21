;****************************************************************************************
;* Copies bytes from ds:[si] to es:[di] in amount of cx                                 *
;* Destroys si, di, bx, cx                                                              *
;****************************************************************************************

.model tiny
.386

.data

	LEN equ 8d	

	source db "To copy", '$'
	dest   db LEN dup ('0'), '$'

.code

org 100h

start:
	lea si, source

	mov ax, ds
	mov es, ax
 	lea di, dest

 	mov cx, LEN

 	call memcpy

 	mov ah, 09h
 	mov dx, di
 	int 21h

exit:
	mov ax, 4c00h
	int 21h

memcpy proc	
	mov bx, cx	

	cld
	rep movsb
	 
	;inc di
	sub di, bx     ; returns di

@@exit:
	ret

memcpy endp


end start