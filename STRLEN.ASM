;****************************************************************************************
;*  Searches for '\0' in str = returns its length in cx ('\0' included)                 *
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
;* Goes through srting, while end of str by es:[di] not finished with 0                 *
;* Returns length in cx	                                                                *
;* Destroys di, al, cx                                                                  *
;****************************************************************************************
strlen proc			
	xor cx, cx
	not cx ; max available value of cx (16 bytes)
	xor al, al
            
	cld
	repne scasb
	
	not cx
	dec cx

	ret
strlen endp				

end start