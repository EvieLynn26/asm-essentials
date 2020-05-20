
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
	jl @@less

	mov al, 1 ; if str1 > str2
	ret

@@equal:		
	mov al, 0
	ret

@@less:
	mov al, -1
	ret

strcmp endp				

end start