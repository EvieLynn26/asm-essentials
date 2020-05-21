;****************************************************************************************
;* Compares strings (frst cx bytes) from ds:[si] and es:[di]                            *
;* Returns result in al: delta of first different symbols                               *
;* If strinds are equal returns 0 in al                                                 *
;****************************************************************************************

.model tiny                           
.386

.data

	sourse db "String to compare F", '$'
	dest   db "String to compare A", '$'
	    
.code

	LEN equ 3d

locals @@

org 100h

extrn check_correct
public memcmp 

start:
	lea si, sourse
	lea di, dest

	mov ax, ds
	mov es, ax      ; assume es = ds

	mov cx, LEN	

	call memcmp

exit:   mov ax, 4c00h
	int 21h


;****************************************************************************************
;*  Destroys si, di, cx                                                                 *
;*  Returns result in al                                                                *
;****************************************************************************************
memcmp proc
	cld
	repe cmpsb 
		
	je @@equal
	jmp @@ne

@@equal:
	mov al, 0
	jmp @@exit

@@ne:
	dec si
	dec di

	mov al, byte ptr [si]
	sub al, byte ptr [di]

@@exit:
	ret

memcmp endp

end start