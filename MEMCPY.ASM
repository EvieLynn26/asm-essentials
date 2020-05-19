;****************************************************************************************
;* Copies bytes from ds:[si] to es:[di] in amount of cx                                 *                                                                         *
;****************************************************************************************

.model tiny
.386

.code

locals @@

org 100h

public memcpy

start:

memcpy proc
	cld
	rep movsb 

@@exit:
	ret

memcpy endp

end start