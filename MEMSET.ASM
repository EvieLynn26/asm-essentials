;****************************************************************************************
;* Sets al-byte to the first cx bytes of es:[di]                                        *
;* Returns start of given block of memory in di                                         *
;* Destroys  bx, cx                                                                     *  
;****************************************************************************************
.model tiny
.386

.data
	LEN equ 8d	

	dest   db LEN dup ('0'), '$'

.code

org 100h

start:
	mov ax, ds
	mov es, ax
 	lea di, dest
	
 	mov al, '#'
 	mov cx, LEN

 	call memset

 	mov ah, 09h
 	mov dx, di
 	int 21h

exit:
	mov ah, 4ch
	int 21h

memset proc
	mov bx, cx		
	
	cld
	rep stosb

	sub di, bx	

	ret
memset endp

end start