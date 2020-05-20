;****************************************************************************************
;*  Searches for '$' in str = returns its length in bx                                  *
;****************************************************************************************

.model tiny
.386

.code

locals @@

org 100h

public strlen

start:
	
strlen proc			
	mov cx, 0ffffh ; max available value of cx (16 bytes)
	mov bx, cx
	mov al, '$'
            
	cld
	repne scasb
	sub bx, cx

	ret
strlen endp				

end start