.model tiny
.code
org 100h

;________________________________________________________
VIDEO_MEM equ 0b800h

SPACE equ 0h
LINE equ 0cdh 
ULF equ 0c9h
URF equ 0bbh
DLF equ 0c8h
DRF equ 0bch
SIDE equ 0bah

COLOR equ 0dh
SHADOW equ 0b2h

aWIDTH = 10d * 2
aHEIGHT = 10d

x1 = 80d - aWIDTH
y1 = 24d - aHEIGHT 
x2 equ 80d + aWIDTH 
y2 equ 24d / 2 + aHEIGHT / 2

NEW_LINE equ 160d - aWidth * 2
;__________________________________________________________

Start:		
		mov ax, VIDEO_MEM
		mov es, ax 		; segment es points to video_memory		
	
		mov di, x1 + y1 * 80d + 20d

		call draw_frame

		mov ax, 4c00h 		; exit
		int 21h

;============================================================
;  Draws frame with left up angle x1, y1 and aWidth aHeight
;============================================================
draw_frame	proc	
	;		call cls;
			
			;;! put params for top line

			mov dh, ULF
			mov dl, URF
			mov al, LINE 
			call draw_line

			;;! put params for middle lines in amount of (height - 2)

			mov cx, aHeight - 2
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
	
		;	call put_label
	
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

			mov byte ptr es:[di], dh
			inc di		
			mov byte ptr es:[di], COLOR
			inc di
 
			mov ah, COLOR 
			mov cx, aWidth - 2
			rep stosw
				
			mov byte ptr es:[di], dl
			inc di
			mov byte ptr es:[di], COLOR
			inc di
								
			add di, NEW_LINE + 2

			mov al, SHADOW
			mov ah, 01010101b ; draws shadow
			mov cx, aWidth
			rep stosw

			sub di, aWidth * 2 + 2 				

			pop dx cx ax	
	
			ret	
draw_line 	endp

cls		 proc
			mov ax, 0
			mov di, 0

			mov ax, VIDEO_MEM
   			mov es, ax

			mov al, SPACE
			mov ah, 00000000b	
			mov cx, 0FFFFh
			rep stosw

			mov ax, 6B00h
			int 21h
				
			ret	
cls 		endp

end Start