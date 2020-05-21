;****************************************************************************************
;* Compares strings from ds:[si] and es:[di]                                            *
;* Returns result in al: 0 if equal, delta of first unmatched symbols ([si] - [di])     *
;****************************************************************************************
.model tiny
.386

.data
	source	db 'To compare aaa', 0
	dest	db 'To compare bbb and get al = -1 ', 0

.code

locals @@

org 100h

start:
	mov ax, ds
	mov es, ax	

	lea si, source
	lea di, dest

	call strcmp
				
exit:
	mov ax, 4c00h
	int 21h

;********************************************************************
;*  Return result in al                                             *
;*  Destroys di, si, cx                                             *
;********************************************************************
strcmp proc			

	call strlen
	mov cx, bx
		
	cld
	repe cmpsb

	dec si
	dec di
	mov al, byte ptr [si]
	sub al, byte ptr [di]
	ret

strcmp endp

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