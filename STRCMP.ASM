
;****************************************************************************************
;* Compares strings from ds:[si] and es:[di]                                            *
;* Returns result in ax: -1 if first str less, 0 if equal, 1 if first in bigger         *
;****************************************************************************************

.model tiny
.386

.data
	source	db 'To compare', '$'
	dest	db 'To compare and get al = 1', '$'

.code

locals @@

org 100h

public strcmp
extern strlen proc

start:
	lea si, sourse
	lea di, dest

	call strcmp
				
	mov ax, 4c00h
	int 21h


strcmp proc			

	call strlen
	inc cx
		
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

strcmp endp				

end start