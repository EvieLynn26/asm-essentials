;****************************************************************************************
;* Compares strings (frst cx bytes) from ds:[si] and es:[di]                            *
;* Returns result in ax: -1 if first str less, 0 if equal, 1 if first in bigger         *
;****************************************************************************************

.model tiny
.386

.code

locals @@

org 100h

public memcmp 

start:

memcmp proc
	cld
	repe cmpsb 
		
	je @@equal
	ja @@bigger
	jb @@less

@@equal:
	mov dx, 0
	jmp @@exit

@@bigger:
	mov ax, 1
	jmp @@exit

@@less:
	mov ax, -1

@@exit:
	ret

memcmp endp

end start