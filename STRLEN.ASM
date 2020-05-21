;****************************************************************************************
;*  Searches for '\0' in str = returns its length in bx ('\0' included)                 *
;****************************************************************************************

.model tiny
.386

.data
	test_str db "Hello!", 0

.code

locals @@

org 100h

start:
        mov ax, ds
        mov es, ax
        lea di, test_str

        call strlen

exit: 
	mov ah, 4ch
	int 21h
	
;****************************************************************************************
;* Goes through srting dec cx, while end of str by es:[di] not finished with 0          *
;* Returns length in bx	                                                                *
;* Destroys al, cx                                                                      *
;****************************************************************************************
strlen proc			
	mov cx, 0ffffh ; max available value of cx (16 bytes)
	mov bx, cx
	mov al, 0
            
	cld
	repne scasb
	sub bx, cx

	ret
strlen endp				

end start