;****************************************************************************************
;* Copies al-byte to the first cx bytes of es:[di]                                      *                                                                         *
;****************************************************************************************

.model tiny
.386

.code

locals @@

org 100h

public memset

start:

memset proc
		cld
		rep stosb	

		ret
memset endp

end start