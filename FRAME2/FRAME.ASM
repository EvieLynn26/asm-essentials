;________________________________________________________
.data

VIDEO_MEM equ 0b800h

SPACE equ 0h
LINE equ 0cdh 
ULF equ 0c9h
URF equ 0bbh
DLF equ 0c8h
DRF equ 0bch
SIDE equ 0bah

lbl2 db " Scan-code of current key-movement: ", '$'

;!!!!!!!!!!!!!!DO NOT DOSCONNECT!!!!!!!!!!!!!!
x1 dw 16d
y1 dw 6d

aWidth  dw 50d
aHeight dw 4d

COLOR db 30d
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SHADOW db 10000101b
;__________________________________________________________


;============================================================
;  Draws frame with left up angle x1, y1 and aWidth aHeight
;
;  Destroys dx, cx, ax
;============================================================
draw_frame	proc

		mov ax, VIDEO_MEM
		mov es, ax 	       ; segment es points to video_memory		

		xor di, di
		add di, word ptr [x1]
		mov ax, word ptr [y1]
		mov bl, 160d
		mul bl
		add di, ax             ; di = y1 * 160 + x1
					
		;;! put params for top line

		mov dh, ULF
		mov dl, URF
		mov al, LINE 
		call draw_line

		;;! put params for middle lines in amount of (height - 2)

		mov cx, word ptr [aHeight] 
		sub cx, 2

		inside:	mov dh, SIDE
			mov dl, SIDE
			mov al, SPACE
			call draw_line
		loop inside

		;;! put params for bottom line
	
		mov dh, DLF 
		mov dl, DRF
		mov al,	LINE
		call draw_line

		; draws down shadow
		add di, 2
		mov byte ptr es:[di], DLF
		inc di		
		mov ah, byte ptr [SHADOW]
		mov byte ptr es:[di], ah
		inc di 

		mov al, LINE 
		xor cx, cx
		add cx, word ptr [aWidth]
		sub cx, 2 			; cx = aWidth - 2
		rep stosw

		push di
		mov bx, offset lbl2
		mov di, PLACE_TO_WRITE + 160d - 36d
		call put_label
		
		;mov bx, offset lbl2
		;mov di, PLACE_TO_WRITE - 36d + 160d * 3d
		;call put_label
		pop di
		
		ret
draw_frame	endp

;====================================================================
;	Procedure draws a line using symbols
;		DH -- left symbol
;		DL -- right symbol
;		AL -- middle symbol
;
;	and a frame to this line
;====================================================================	
draw_line 	proc
		push ax cx dx

		;-- set two bytes for left symb 	
		mov byte ptr es:[di], dh
		inc di		
 
		mov ah, byte ptr [COLOR]
		mov byte ptr es:[di], ah
		inc di 

		xor cx, cx
		add cx, word ptr [aWidth]
		sub cx, 2 			; cx = aWidth - 2
		rep stosw
				
		mov byte ptr es:[di], dl
		inc di
		mov byte ptr es:[di], ah
		inc di				

		add di, 160d

		mov byte ptr es:[di], dl
		inc di
		mov ah, byte ptr [SHADOW]
		mov byte ptr es:[di], ah
		inc di

		sub di, word ptr [aWidth]
		sub di, word ptr [aWidth]
		sub di, 2
	
		pop dx cx ax	
	
		ret	
draw_line 	endp

;=================================================================
;   Takes two_digit_nums from bx with spaces between
;
;   Destroys bx, cx, dl
;=================================================================
console_params 	proc
		; si = 80h

		lea bx, x1  ; bx points to current arg

		mov cx, 4   ; 4 times read args
		
		@@loop:
			add si, 2   ; si on the first symb

			call bytes_to_num
			mov word ptr [bx], ax

			add bx, 2

		loop @@loop

		add si, 2

		call bytes_to_num
		mov byte ptr [bx], al

		;and al, 10000111b
		;mov byte ptr [SHADOW], al

		ret
console_params  endp


;==================================================================
;   si -- source of bytes with numbers to convert
;   
;   returns num in ax
;
;   Destroys dl
;==================================================================
bytes_to_num    proc
		mov dl, 10d
                xor ax, ax
                mov al, byte ptr [si]
                sub al, '0'
                mul dl

                inc si
                add al, byte ptr [si]
                sub al, '0'
                		
		ret
bytes_to_num    endp

;=======================================================
;  Entry: bx -- offset lbl, di -- place to write
;  Destroys bx, di, ax, dx	
;=======================================================
put_label       proc

		cmp byte ptr [bx], '$'
		je @@ret

@@print:	
		mov al, byte ptr [bx]
		mov byte ptr es:[di], al
		add di, 2
		inc bx
		cmp byte ptr [bx], '$'
		jne @@print

@@ret:		ret
put_label       endp


end start       
