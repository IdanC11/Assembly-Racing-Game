IDEAL
MODEL large
STACK 100h
P386
; ---- MACROS ----
; ---- draw rectangle ----
MACRO macro_draw_rectange _x, _y, _color, _width, _height
	push _x ; x
	push _y ; y
	push _color ; color
	push _width ; width
	push _height ; height
	call draw_rectangle
ENDM
; ---- close file ----
MACRO macro_close_file _filehandle
	mov ah,3Eh
	mov bx,[_filehandle]
	int 21h
ENDM

;---- variables ----
DATASEG
;rules
RulesText0  db " GAME INSTRUCTIONS:                                                            ",13,10
			db "                                                                               $"
RulesText1	db " * The red car can only move on the grey road.                                 ",13,10
			db "   In order to move the car to the left, press on the left arrow on the        ",13,10
			db "   keyboard.                                                                   ",13,10
			db "   In order to move the car to the right, press on the right arrow on the      ",13,10
			db "   keyboard.                                                                   ",13,10
			db "                                                                               $"
RulesText2	db " * Survivng more time increases your score ( the score appears on the top      ",13,10
			db "   left corner of the game screen).                                            ",13,10
			db "                                                                               $"
RulesText3	db " * In order to keep driving through the obstacles, move the car to the         ",13,10
			db "   left/right.                                                                 ",13,10
			db "                                                                               $"
RulesText4	db " * As time passes, the speed of the car will increase.                         ",13,10
			db "                                                                               $"
RulesText5	db " * Every player starts with 3 red hearts, when hitting an obstacle, 1 heart    ",13,10
			db "   disappears. Once the player has 0 hearts, he loses the game.                ",13,10
			db "                                                                               $"
RulesText6	db " * The goal is to stay on the road for as long as you can.                     ",13,10
			db "                                                                               $"
RulesText7	db "                                HAVE FUN :)                                    ",13,10
			db "                  Press 'Enter' to return to the Main Menu                     ",13,10
			db "                                                                              $"
;20 possible (triplets) combinations for obstacles
;  _________________
; |     |     |     |
; |  0  |  1  |  2  |
; |_____|_____|_____|
; |     |     |     |
; |  3  |  4  |  5  |
; |_____|_____|_____|
; |     |     |     |
; |  6  |  7  |  8  |
; |_____|_____|_____|
; |     |     |     |
; |  9  |  10 |  11 |
; |_____|_____|_____|
obstacles_square_location_triplets_len db 20
obstacles_square_location_triplets 	db 0,1,7
									db 0,4,7
									db 0,5,6
									db 1,2,9
									db 1,5,6
									db 1,5,10
									db 1,7,10
									db 1,8,11
									db 2,3,7
									db 2,5,7
									db 2,5,9
									db 2,7,9
									db 2,9,10
									db 3,4,7
									db 3,7,10
									db 4,5,10
									db 4,6,11
									db 4,8,10
									db 6,7,9
									db 8,9,11

;							length,indexes...
obstacles_transition_table	db 19, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,-1
							db 19, 0, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,-1
							db 18, 0, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,-1,-1
							db 19, 0, 1, 2, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,-1
							db 13, 1, 2, 3, 5, 7, 9,10,11,12,15,16,17,19,-1,-1,-1,-1,-1,-1,-1
							db 17, 1, 2, 3, 4, 6, 7, 8, 9,10,11,12,14,15,16,17,18,19,-1,-1,-1
							db 13, 1, 2, 3, 4, 7, 9,10,11,12,15,16,17,19,-1,-1,-1,-1,-1,-1,-1
							db 18, 0, 2, 3, 4, 5, 6, 8, 9,10,11,12,13,14,15,16,17,18,19,-1,-1
							db 17, 1, 2, 3, 4, 5, 6, 7, 9,10,11,12,14,15,16,17,18,19,-1,-1,-1
							db 19, 0, 1, 2, 3, 4, 5, 6, 7, 8,10,11,12,13,14,15,16,17,18,19,-1
							db 13, 1, 2, 3, 4, 7, 9,10,11,12,15,16,17,19,-1,-1,-1,-1,-1,-1,-1
							db 17, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,12,14,15,16,17,18,19,-1,-1,-1
							db 18, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,13,15,16,17,18,19,-1,-1
							db 18, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,14,15,16,17,18,19,-1,-1
							db 19, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,15,16,17,18,19,-1
							db 19, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,16,17,18,19,-1
							db 18, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,15,17,18,19,-1,-1
							db 15, 0, 2, 4, 5, 6, 7, 8, 9,10,11,13,15,16,18,19,-1,-1,-1,-1,-1
							db 19, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,19,-1
							db 17, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,14,15,16,17,18,-1,-1,-1
current_obstacles_state db -1

;18 possible (triplets) combinations in 'trees_square_location_triplets'
;  _______________________________
; |		|					|	  |
; |	 0	|					|  4  |
; |_____|					|_____|
; |		|					|	  |
; |	 1	|					|  5  |
; |_____|					|_____|
; |		|					|	  |
; |	 2	|					|  6  |
; |_____|					|_____|
; |		|					|	  |
; |	 3	|					|  7  |
; |_____|___________________|_____|
trees_square_location_triplets_len db 18
trees_square_location_triplets 	db 0,2,4
								db 0,2,5
								db 0,2,6
								db 0,2,7
								db 0,3,4
								db 0,3,5
								db 0,3,6
								db 0,3,7
								db 0,4,6
								db 0,4,7
								db 0,5,7
								db 1,3,4
								db 1,3,5
								db 1,3,6
								db 1,3,7
								db 1,4,6
								db 1,4,7
								db 1,5,7

grid_resolution db 50
left_shoulder_limit db 85
right_shoulder_limit db 236

rnd_seed dw ?
rnd_number dw ?
rnd_limit db 1 dup(0) ;random max limit is 255

note dw 9B5Ch
soundDelay dw 0
temp dw 4
stor dw 0

filename_gameOver db 'gameovr.bmp',0
filehandle_gameOver dw ?
filenameMain db 'mainbg.bmp',0
filehandleMain dw ?
filenameBackGround db 'gamebg.bmp',0
filehandleBackGround dw ?
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 320 dup (0)
ErrorMsg db 'Error', 13, 10 ,'$'
ScoreText db 'Score:',13,10, '$'
GearText db 'Gear:',13,10, '$'
Clock equ es:6Ch
FirstClockTick dw 1 dup(0)
TimerTickCurrent dw 1 dup(0)
const10 dw 1 dup(10)
ScoreCounterText db '           ',13,10,'$'
ScoreCharCounter db 1 dup(0)
FirstScreenOffset dw 1 dup(200)
SecondScreenOffset dw 1 dup(0)
CurrentScreenOffset dw 1 dup(0)
car_main_color dw 14
car_middle_axis_x dw 160
car_start_row dw 170
car_width dw 15
car_height dw 25
transparent_color_code equ 0FDh
heart_symbol dw 3
lives dw 3
gear db 1
gear_lut db 4, 8, 12, 16, 20
gear_speed_change_lut db 7, 25, 50, 75
;values of 'gear_speed_change_lut' are divided by 4 in order to get into one byte: 0, 28, 100, 200, 300
max_gear db 5
collision_alerted_counter dw 0

;screen under update:
; 1 - first screen;
; 2 - second
ScreenUnderUpdate dw 1 dup(2)

;small tree variables
stree_header db 54 dup (0)
stree_palette db 256*4 dup (0)
stree_fname db 'stree.bmp',0
stree_fhandle dw ?
stree_x dw 1 dup(0);x placement
stree_y dw 1 dup(0);y placement
stree_w dw 1 dup(32);width
stree_h dw 1 dup(32);height
stree_square_idx db ?

;medium tree variables
mtree_header db 54 dup (0)
mtree_palette db 256*4 dup (0)
mtree_fname db 'mtree.bmp',0
mtree_fhandle dw ?
mtree_x dw 1 dup(0);x placement
mtree_y dw 1 dup(0);y placement
mtree_w dw 1 dup(48);width
mtree_h dw 1 dup(48);height
mtree_square_idx db ?

;large tree variables
ltree_header db 54 dup (0)
ltree_palette db 256*4 dup (0)
ltree_fname db 'ltree.bmp',0
ltree_fhandle dw ?
ltree_x dw 1 dup(0);x placement
ltree_y dw 1 dup(0);y placement
ltree_w dw 1 dup(48);width
ltree_h dw 1 dup(48);height
ltree_square_idx db ?

;rock2p variables
rock2p_header db 54 dup (0)
rock2p_palette db 256*4 dup (0)
rock2p_fname db 'rock2p.bmp',0
rock2p_fhandle dw ?
rock2p_w dw 1 dup(48);width
rock2p_h dw 1 dup(48);height
rock2p_x dw 1 dup(0FFh);x placement
rock2p_y dw 1 dup(0FFh);y placement
rock2p_square_idx db ?

;chicken variables
chicken_header db 54 dup (0)
chicken_palette db 256*4 dup (0)
chicken_fname db 'chicken.bmp',0
chicken_fhandle dw ?
chicken_w dw 1 dup(48);width
chicken_h dw 1 dup(48);height
chicken_x dw 1 dup(0FFh);x placement
chicken_y dw 1 dup(0FFh);y placement
chicken_square_idx db ?

;cow variables
cow_header db 54 dup (0)
cow_palette db 256*4 dup (0)
cow_fname db 'cow.bmp',0
cow_fhandle dw ?
cow_w dw 1 dup(48);width
cow_h dw 1 dup(48);height
cow_x dw 1 dup(0FFh);x placement
cow_y dw 1 dup(0FFh);y placement
cow_square_idx db ?

; default background screen
FARDATA empty_background_screen
MainRoadBuffer db 320*200 dup (0)

; first moving screen
FARDATA first_moving_screen
FirstMovingScreen db 320*200 dup (0)

; second moving screen
FARDATA second_moving_screen
SecondMovingScreen db 320*200 dup (0)


;---- code ----
CODESEG
;----------------------------------------------------------------
proc enter_graphic_mode
	mov ax,13h
	int 10h
	ret
endp enter_graphic_mode
;--------------------------------------------------
proc exit_graphic_mode
	mov ax,2
	int 10h
	ret
endp exit_graphic_mode
;-----------------------------------------------------------------------------------
proc rules
	push es
	mov ax,@data 
	mov es,ax

	mov bp,OFFSET RulesText0 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,0Fh 		; attribute - white - color
	mov cx,160 		; length of string
	mov dh,0		; row to put string
	mov dl,0 		; column to put string
	int 10h 		; call BIOS service
	
	mov bp,OFFSET RulesText1 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,05h 		; attribute - magenta - color
	mov cx,480 		; length of string
	mov dh,2		; row to put string
	mov dl,0 		; column to put string
	int 10h 		; call BIOS service
	
	mov bp,OFFSET RulesText2 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,09h 		; attribute - light blue - color
	mov cx,240 		; length of string
	mov dh,8		; row to put string
	mov dl,0 		; column to put string
	int 10h 		; call BIOS service
	
	mov bp,OFFSET RulesText3 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,0Bh 		; attribute - light cyan - color
	mov cx,240 		; length of string
	mov dh,11		; row to put string
	mov dl,0 		; column to put string
	int 10h 		; call BIOS service
	
	mov bp,OFFSET RulesText4 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,0Ah 		; attribute - light green - color
	mov cx,160 		; length of string
	mov dh,14		; row to put string
	mov dl,0 		; column to put string
	int 10h 		; call BIOS service
	
	mov bp,OFFSET RulesText5 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,0Eh 		; attribute - yellow - color
	mov cx,240 		; length of string
	mov dh,16		; row to put string
	mov dl,0 		; column to put string
	int 10h 		; call BIOS service
	
	mov bp,OFFSET RulesText6 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,0Ch 		; attribute - light red - color
	mov cx,160 		; length of string
	mov dh,19		; row to put string
	mov dl,0 		; column to put string
	int 10h 		; call BIOS service
	
	mov bp,OFFSET RulesText7 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,04h 		; attribute - red - color
	mov cx,160 		; length of string
	mov dh,21		; row to put string
	mov dl,0 		; column to put string
	int 10h 		; call BIOS service
	
	pop es
	ret
endp rules
;-----------------------------------------------------------------------------------
;-------------------------------------------
proc get_score_string
	mov ax, [TimerTickCurrent]
	mov [ScoreCharCounter], 0
	next_digit:
		inc [ScoreCharCounter]
		xor dx,dx
		div [const10]
		add dl,'0'		; turn it into char
		push dx
		cmp ax,0
		jne next_digit

	xor si,si
	build_score_string:
		pop dx
		mov bx, offset ScoreCounterText
		mov [word ptr bx + si], dx
		inc si
		dec [ScoreCharCounter]
		cmp [ScoreCharCounter],0
		jne build_score_string
		
	ret
endp get_score_string
;-------------------------------------------
proc print_score
	mov ax, 40h
	mov es, ax
	mov ax, [Clock]
	mov bx,offset FirstClockTick
	sub ax, [bx]
	shr ax,2 ; divide by 2, to get it closer to 0.5 seconds
	mov bx,offset TimerTickCurrent
	mov [bx],ax

	push es
	mov ax,@data 
	mov es,ax
	mov bp,OFFSET ScoreText 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,5 		; attribute - magenta - color
	mov cx,6 		; length of string
	mov dh,0		; row to put string
	mov dl,0 		; column to put string
	int 10h 		; call BIOS service

	call get_score_string
	mov bp,offset ScoreCounterText
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,5 		; attribute - magenta - color
	mov cx,si 		; length of string
	mov dh,0		; row to put string
	mov dl,6 		; column to put string
	int 10h 		; call BIOS service

	;print hearts (lives)
	mov cx,[lives]
	cmp cx,0
	je print_gear
	mov bp,OFFSET heart_symbol 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,1 		; color
	mov cx,1 		; length of string
	mov dh,0		; row to put string
	mov dl,110		; column to put string
	int 10h 		; call BIOS service
	mov cx,[lives]
	dec cx
	cmp cx,0
	je print_gear
	print_hearts:
		inc dl		; column to put string
		int 10h 	; call BIOS service
		loop print_hearts
	
print_gear:
	;print gear
	mov bp,OFFSET GearText 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,6 		; color
	mov cx,5 		; length of string
	mov dh,0		; row to put string
	mov dl,114 		; column to put string
	int 10h 		; call BIOS service

	mov al,[gear]
	add al,'0'
	mov [ScoreCharCounter],al
	mov bp,OFFSET ScoreCharCounter 	; ES:BP points to message
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,6 		; color
	mov cx,1 		; length of string
	mov dh,0		; row to put string
	mov dl,119		; column to put string
	int 10h 		; call BIOS service
	
	pop es
	ret
endp print_score
;-----------------------------------------------------------------------------------
proc clear_keyb
	push es    ;preserve ES
	push di    ;preserve DI
	mov ax,40h ;BIOS segment in AX
	mov es,ax  ;transfer to ES
	mov ax,1Ah ;keyboard head pointer in AX
	mov di,ax  ;transfer to DI
	mov ax,1Eh ;keyboard buffer start in AX
	inc di     ;bump pointer to...
	inc di     ;...keyboard tail pointer
	pop di     ;restore DI
	pop es     ;restore ES

	ret           
endp clear_keyb
;-----------------------------------------------------------------------------------
proc sound_delay
	mov ah,00h    ;function 0 - get system timer tick
	int 01Ah      ;call ROM BIOS time-of-day services
	mov bx,offset temp
	add dx,[bx]   ;add our delay value to DX
	mov bx,dx     ;store result in BX
	pozz:
	int 01Ah      ;call ROM BIOS time-of-day services
	cmp dx,bx     ;has the delay duration passed?
	jl pozz       ;no, so go check again

	ret    
endp sound_delay
;-----------------------------------------------------------------------------------
proc sounder
	mov al,10110110b    ;load control word
	out 43h,al          ;send it
	mov bx,offset stor
	mov ax,[bx]         ;tone frequency
	out 42h,al          ;send LSB
	mov al,ah           ;move MSB to AL
	out 42h,al          ;save it
	in al,61h           ;get port 61 state
	or al,00000011b     ;turn on speaker
	out 61h,al          ;speaker on now
	call sound_delay    ;go pause a little bit
	and al,11111100b    ;clear speaker enable
	out 61h,al          ;speaker off now
	call Clear_keyb     ;go clear the keyboard buffer

	ret      
endp sounder
;-----------------------------------------------------------------------------------
proc fail_sound
	mov bx,offset stor
	mov [word ptr bx],8609
	mov bx,offset soundDelay
	mov [word ptr bx],100
	call sounder
	mov bx,offset stor
	mov [word ptr bx],13666
	mov bx,offset soundDelay
	mov [word ptr bx],400
	call sounder
	ret
endp fail_sound
;-----------------------------------------------------------------------------------
proc OpenFile_GameOver
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename_gameOver
	int 21h
	jc openerror_gameOver
	mov [filehandle_gameOver], ax
	ret
	openerror_gameOver:
	mov dx, offset ErrorMsg
	mov ah, 9h
	int 21h
	ret
endp OpenFile_GameOver
;-----------------------------------------------------------------------------------
proc ReadHeader_GameOver
	; Read BMP file header, 54 bytes
	mov ah,3fh
	mov bx,[filehandle_gameOver]
	mov cx,54
	mov dx,offset Header
	int 21h
	ret
endp ReadHeader_GameOver
;-----------------------------------------------------------------------------------
proc ReadPalette_GameOver
	; Read BMP file color palette, 256 colors * 4 bytes (400h)
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	ret
	endp ReadPalette_gameOver
	proc CopyPal_gameOver
	; Copy the colors palette to the video memory
	; The number of the first color should be sent to port 3C8h
	; The palette is sent to port 3C9h
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h
	inc dx
	PalLoop_gameOver:
	; Note: Colors in a BMP file are saved as BGR values rather than RGB .
	mov al,[si+2] ; Get red value .
	shr al,2 ; Max. is 255, but video palette maximal
	; value is 63. Therefore dividing by 4.
	out dx,al ; Send it .
	mov al,[si+1] ; Get green value .
	shr al,2
	out dx,al ; Send it .
	mov al,[si] ; Get blue value .
	shr al,2
	out dx,al ; Send it .
	add si,4 ; Point to next color .
	; (There is a null chr. after every color.)
	loop PalLoop_gameOver
	ret
	endp CopyPal_gameOver
	proc CopyBitmap_gameOver
	; BMP graphics are saved upside-down .
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	mov ax, 0A000h
	mov es, ax
	mov cx,200
	PrintBMPLoop_gameOver :
	push cx
	; di = cx*320, point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	; Read one line
	mov ah,3fh
	mov cx,320
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,320
	mov si,offset ScrLine
	rep movsb ; Copy line to the screen
	 ;rep movsb is same as the following code :
	 ;mov es:di, ds:si
	 ;inc si
	 ;inc di
	 ;dec cx
	;loop until cx=0
	pop cx
	loop PrintBMPLoop_GameOver
	ret
endp CopyBitmap_GameOver
;-----------------------------------------------------------------------------------
proc GameOverScreen
	call OpenFile_GameOver
	call ReadHeader_GameOver
	call ReadPalette_GameOver
	call CopyPal_GameOver
	call CopyBitmap_GameOver
	macro_close_file filehandle_gameOver
	
	;print the final score
	push es
	mov ax,@data 
	mov es,ax
	call get_score_string
	mov bp,offset ScoreCounterText
	mov ah,13h 		; function 13 - write string
	mov al,01h 		; attrib in bl,move cursor
	xor bh,bh 		; video page 0
	mov bl,5 		; attribute - magenta - color
	mov cx,si
	shr cx,1
	mov dl,60 		; column to put string
	sub dl,cl		; try to place the score in the middle of the box
	mov dh,14		; row to put string
	mov cx,si 		; length of string
	int 10h 		; call BIOS service
	pop es
	
	ret
endp GameOverScreen
;-----------------------------------------------------------------------------------
proc OpenFile
	push bp
	mov bp,sp
	
	mov ah, 3Dh
	xor al, al
	mov dx,[bp+6]
	int 21h
	jc openerror
	mov bx,[bp+8]
	mov [bx], ax
	
	pop bp
	ret 6
openerror :
	mov dx,[bp+10]
	mov ah, 9h
	int 21h
	ret
endp OpenFile
;-------------------------------------------
proc ReadPalette
	; Read BMP file color palette, 256 colors * 4 bytes (400h)
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	ret
endp ReadPalette
;-----------------------------------------------------
proc CopyPal
; Copy the colors palette to the video memory
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h
	inc dx
	PalLoop:
		; Note: Colors in a BMP file are saved as BGR values rather than RGB .
		mov al,[si+2] ; Get red value .
		shr al,2 ; Max. is 255, but video palette maximal
		; value is 63. Therefore dividing by 4.
		out dx,al ; Send it .
		mov al,[si+1] ; Get green value .
		shr al,2
		out dx,al ; Send it .
		mov al,[si] ; Get blue value .
		shr al,2
		out dx,al ; Send it .
		add si,4 ; Point to next color .
		; (There is a null chr. after every color.)
		loop PalLoop
	ret
endp CopyPal
;-------------------------------------------
proc set_gear
	mov bx,offset gear
	mov al,[bx]
	dec al ;calculate entry to gear_speed_change_lut
	mov bx,offset gear_speed_change_lut
	xlat ;get the value from the LUT in 'al'
	xor ah,ah
	shl ax,2 ;multiply by 4, to get the real value
	;check if it's time to speed up
	mov bx,offset TimerTickCurrent
	mov cx,[bx]
	cmp cx,ax
	jb end_of_set_gear
	
	;speed_up
	mov bx,offset gear
	mov al,[bx]
	mov bx,offset max_gear
	cmp al,[bx] ;check if it's the max gear
	jae end_of_set_gear
	mov bx,offset gear
	mov al,[bx]
	inc al
	mov [bx],al

end_of_set_gear:
	ret
endp set_gear
;-------------------------------------------
proc get_random_number
	push bx
	
	mov bx,offset rnd_number
	mov ax,[bx]
	mul ax ;rnd_number^2
	mov dx,[Clock];add some clock ticks
	add ax,dx
	shr ax,4 ;take 8 bit in the middle of 16 bit
	xor ah,ah;zero the high bits
	;get random limit (max 255)
	mov bx,offset rnd_limit
	mov dl,[bx]
	div dl
	mov bx,offset rnd_number
	mov al,ah
	xor ah,ah
	mov [bx],ax

	pop bx
	ret
endp get_random_number
;-------------------------------------------
proc print_stree
	;prepare arguments for openfile
	push offset ErrorMsg
	push offset stree_fhandle
	push offset stree_fname
	call OpenFile
	;read header
	mov ah,3Fh
	mov bx,[stree_fhandle]
	mov cx,54
	mov dx,offset stree_header
	int 21h
	;read palette
	call ReadPalette
	;copy palette
	call CopyPal
	;copy bitmap
	
	;choose row from the index
	push bx
	mov bx,offset stree_square_idx
	mov al,[bx]
	xor ah,ah
	mov dl,4
	div dl
	mov cx,ax
	xchg ah,al
	mov bx,offset grid_resolution
	mov dl,[bx]
	mul dl
	push ax ;save y offset
	
	;choose column from the index
	mov ax,cx
	xor ah,ah
	mul [right_shoulder_limit]
	push ax ;save x offset
	;add some x offset
	xor ah,ah
	mov al,[left_shoulder_limit]
	sub ax,[stree_w]
	mov [rnd_limit],al
	call get_random_number ;choose random x offset
	mov dx,[rnd_number]
	pop ax
	add ax,dx
	push ax ;save x offset

	;restore coordinates
	pop ax ;x coordinate in ax
	pop dx ;y coordinate in dx
	pop bx

	;update tree coordinates
	mov [stree_x],ax
	mov [stree_y],dx
	
	mov cx,[stree_h]
print_image_rows:
		push cx
		
		push ax ;x coordinate in ax
		push dx ;y coordinate in dx
		;read one line from the file
		mov ah,3fh
		mov cx,[stree_w]
		mov dx,offset ScrLine
		int 21h
		pop dx
		mov ax,dx
		mov di,dx
		shl dx,6
		shl di,8
		add di,dx
		mov dx,ax
		pop ax
		add di,ax
		push ax
		push dx
		;copy to the screen buffer
		push es
		push bx
		
		mov bx,offset ScreenUnderUpdate
		mov ax,[bx]
		cmp ax,1
		je update_first_screen
		mov ax, second_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
		jmp cont_update
	update_first_screen:
		mov ax, first_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
	cont_update:
		mov bx,offset ScrLine
		xor si,si
		mov cx,[stree_w]
		shr cx,1
		copy_line:
			mov ax,[word bx+si]
			mov [es:[di]],ax
			add si,2
			add di,2
			loop copy_line

		pop bx
		pop es
		pop dx
		inc dx
		pop ax
		pop cx
		loop print_image_rows

	;close file
	macro_close_file stree_fhandle

	ret
endp print_stree
;-------------------------------------------
proc print_mtree
	;prepare arguments for openfile
	push offset ErrorMsg
	push offset mtree_fhandle
	push offset mtree_fname
	call OpenFile
	;read header
	mov ah,3Fh
	mov bx,[mtree_fhandle]
	mov cx,54
	mov dx,offset mtree_header
	int 21h
	;read palette
	call ReadPalette
	;copy palette
	call CopyPal
	;copy bitmap
	
	;choose row from the index
	push bx
	mov bx,offset mtree_square_idx
	mov al,[bx]
	xor ah,ah
	mov dl,4
	div dl
	mov cx,ax
	xchg ah,al
	mov bx,offset grid_resolution
	mov dl,[bx]
	mul dl
	push ax ;save y offset
	
	;choose column from the index
	mov ax,cx
	xor ah,ah
	mul [right_shoulder_limit]
	push ax ;save x offset
	;add some x offset
	xor ah,ah
	mov al,[left_shoulder_limit]
	sub ax,[mtree_w]
	mov [rnd_limit],al
	call get_random_number ;choose random x offset
	mov dx,[rnd_number]
	pop ax
	add ax,dx
	push ax ;save x offset
	
	;restore coordinates
	pop ax ;x coordinate in ax
	pop dx ;y coordinate in dx
	pop bx
	
	;update tree coordinates
	mov [mtree_x],ax
	mov [mtree_y],dx
	
	mov cx,[mtree_h]
mprint_image_rows:
		push cx
		
		push ax ;x coordinate in ax
		push dx ;y coordinate in dx
		;read one line from the file
		mov ah,3fh
		mov cx,[mtree_w]
		mov dx,offset ScrLine
		int 21h
		pop dx
		mov ax,dx
		mov di,dx
		shl dx,6
		shl di,8
		add di,dx
		mov dx,ax
		pop ax
		add di,ax
		push ax
		push dx
		;copy to the screen buffer
		push es
		push bx
		
		mov bx,offset ScreenUnderUpdate
		mov ax,[bx]
		cmp ax,1
		je update_first_screen_m
		mov ax, second_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
		jmp cont_update_m
	update_first_screen_m:
		mov ax, first_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
	cont_update_m:
		mov bx,offset ScrLine
		xor si,si
		mov cx,[mtree_w]
		shr cx,1
		copy_line_m:
			mov ax,[word bx+si]
			mov [es:[di]],ax
			add si,2
			add di,2
			loop copy_line_m

		pop bx
		pop es
		pop dx
		inc dx
		pop ax
		pop cx
		loop mprint_image_rows

	;close file
	macro_close_file mtree_fhandle

	ret
endp print_mtree
;-------------------------------------------
proc print_ltree
	;prepare arguments for openfile
	push offset ErrorMsg
	push offset ltree_fhandle
	push offset ltree_fname
	call OpenFile
	;read header
	mov ah,3Fh
	mov bx,[ltree_fhandle]
	mov cx,54
	mov dx,offset ltree_header
	int 21h
	;read palette
	call ReadPalette
	;copy palette
	call CopyPal
	;copy bitmap
	
	;choose row from the index
	push bx
	mov bx,offset ltree_square_idx
	mov al,[bx]
	xor ah,ah
	mov dl,4
	div dl
	mov cx,ax
	xchg ah,al
	mov bx,offset grid_resolution
	mov dl,[bx]
	mul dl
	push ax ;save y offset
	
	;choose column from the index
	mov ax,cx
	xor ah,ah
	mul [right_shoulder_limit]
	push ax ;save x offset
	;add some x offset
	xor ah,ah
	mov al,[left_shoulder_limit]
	sub ax,[ltree_w]
	mov [rnd_limit],al
	call get_random_number ;choose random x offset
	mov dx,[rnd_number]
	pop ax
	add ax,dx
	push ax ;save x offset
	
	;restore coordinates
	pop ax ;x coordinate in ax
	pop dx ;y coordinate in dx
	pop bx
	
	;update tree coordinates
	mov [ltree_x],ax
	mov [ltree_y],dx
	
	mov cx,[ltree_h]
lprint_image_rows:
		push cx
		
		push ax ;x coordinate in ax
		push dx ;y coordinate in dx
		;read one line from the file
		mov ah,3fh
		mov cx,[ltree_w]
		mov dx,offset ScrLine
		int 21h
		pop dx
		mov ax,dx
		mov di,dx
		shl dx,6
		shl di,8
		add di,dx
		mov dx,ax
		pop ax
		add di,ax
		push ax
		push dx
		;copy to the screen buffer
		push es
		push bx
		
		mov bx,offset ScreenUnderUpdate
		mov ax,[bx]
		cmp ax,1
		je update_first_screen_l
		mov ax, second_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
		jmp cont_update_l
	update_first_screen_l:
		mov ax, first_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
	cont_update_l:
		mov bx,offset ScrLine
		xor si,si
		mov cx,[ltree_w]
		shr cx,1
		copy_line_l:
			mov ax,[word bx+si]
			mov [es:[di]],ax
			add si,2
			add di,2
			loop copy_line_l

		pop bx
		pop es
		pop dx
		inc dx
		pop ax
		pop cx
		loop lprint_image_rows

	;close file
	macro_close_file ltree_fhandle

	ret
endp print_ltree
;-------------------------------------------
proc print_rock2p
	;prepare arguments for openfile
	push offset ErrorMsg
	push offset rock2p_fhandle
	push offset rock2p_fname
	call OpenFile

	;read header
	mov ah,3Fh
	mov bx,[rock2p_fhandle]
	mov cx,54
	mov dx,offset rock2p_header
	int 21h
	;read palette
	call ReadPalette
	;copy palette
	call CopyPal
	;copy bitmap

	;choose row from the index
	push bx
	mov bx,offset rock2p_square_idx
	mov al,[bx]
	xor ah,ah
	mov dl,3
	div dl
	mov cx,ax
	mov bx,offset grid_resolution
	mov dl,[bx]
	mul dl
	push ax ;save y offset
	
	;choose column from the index
	mov ax,cx
	xchg ah,al
	xor ah,ah
	mul dl
	mov bx,offset left_shoulder_limit
	xor dh,dh
	mov dl,[bx]
	add ax,dx
	push ax ;save x offset
	
	;restore coordinates
	pop ax ;x coordinate in ax
	pop dx ;y coordinate in dx
	;update rock coordinates
	mov [rock2p_x],ax
	mov [rock2p_y],dx
	pop bx
	mov cx,[rock2p_h]
print_image_rows_r2p:
		push cx
		
		push ax ;x coordinate in ax
		push dx ;y coordinate in dx
		;read one line from the file
		mov ah,3fh
		mov cx,[rock2p_w]
		mov dx,offset ScrLine
		int 21h
		pop dx
		mov ax,dx
		mov di,dx
		shl dx,6
		shl di,8
		add di,dx
		mov dx,ax
		pop ax
		add di,ax
		push ax
		push dx
		;copy to the screen buffer
		push es
		push bx
		
		mov bx,offset ScreenUnderUpdate
		mov ax,[bx]
		cmp ax,1
		je update_first_screen_r2p
		mov ax, second_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
		jmp cont_update_r2p
	update_first_screen_r2p:
		mov ax, first_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
	cont_update_r2p:
		mov bx,offset ScrLine
		xor si,si
		mov cx,[rock2p_w]
		copy_line_r2p:
			mov al,[byte bx+si]
			;do not print background pixels
			cmp al,transparent_color_code
			je loop_cont_r2p
			mov [es:[di]],al
			loop_cont_r2p:
			inc si
			inc di
			loop copy_line_r2p

		pop bx
		pop es
		pop dx
		inc dx
		pop ax
		pop cx
		loop print_image_rows_r2p

	;close file
	macro_close_file rock2p_fhandle

	ret
endp print_rock2p
;-------------------------------------------
proc print_chicken
	;prepare arguments for openfile
	push offset ErrorMsg
	push offset chicken_fhandle
	push offset chicken_fname
	call OpenFile

	;read header
	mov ah,3Fh
	mov bx,[chicken_fhandle]
	mov cx,54
	mov dx,offset chicken_header
	int 21h
	;read palette
	call ReadPalette
	;copy palette
	call CopyPal
	;copy bitmap

	;choose row from the index
	push bx
	mov bx,offset chicken_square_idx
	mov al,[bx]
	xor ah,ah
	mov dl,3
	div dl
	mov cx,ax
	mov bx,offset grid_resolution
	mov dl,[bx]
	mul dl
	push ax ;save y offset
	
	;choose column from the index
	mov ax,cx
	xchg ah,al
	xor ah,ah
	mul dl
	mov bx,offset left_shoulder_limit
	xor dh,dh
	mov dl,[bx]
	add ax,dx
	push ax ;save x offset
	
	;restore coordinates
	pop ax ;x coordinate in ax
	pop dx ;y coordinate in dx
	;update chicken coordinates
	mov [chicken_x],ax
	mov [chicken_y],dx
	pop bx
	
	mov cx,[chicken_h]
print_image_rows_chicken:
		push cx
		
		push ax ;x coordinate in ax
		push dx ;y coordinate in dx
		;read one line from the file
		mov ah,3fh
		mov cx,[chicken_w]
		mov dx,offset ScrLine
		int 21h
		pop dx
		mov ax,dx
		mov di,dx
		shl dx,6
		shl di,8
		add di,dx
		mov dx,ax
		pop ax
		add di,ax
		push ax
		push dx
		;copy to the screen buffer
		push es
		push bx
		
		mov bx,offset ScreenUnderUpdate
		mov ax,[bx]
		cmp ax,1
		je update_first_screen_chicken
		mov ax, second_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
		jmp cont_update_chicken
	update_first_screen_chicken:
		mov ax, first_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
	cont_update_chicken:
		mov bx,offset ScrLine
		xor si,si
		mov cx,[chicken_w]
		copy_line_chicken:
			mov al,[byte bx+si]
			;do not print background pixels
			cmp al,transparent_color_code
			je loop_cont_chicken
			mov [es:[di]],al
			loop_cont_chicken:
			inc si
			inc di
			loop copy_line_chicken

		pop bx
		pop es
		pop dx
		inc dx
		pop ax
		pop cx
		loop print_image_rows_chicken

	;close file
	macro_close_file chicken_fhandle

	ret
endp print_chicken
;-------------------------------------------
proc print_cow
	;prepare arguments for openfile
	push offset ErrorMsg
	push offset cow_fhandle
	push offset cow_fname
	call OpenFile

	;read header
	mov ah,3Fh
	mov bx,[cow_fhandle]
	mov cx,54
	mov dx,offset cow_header
	int 21h
	;read palette
	call ReadPalette
	;copy palette
	call CopyPal
	;copy bitmap

	;choose row from the index
	push bx
	mov bx,offset cow_square_idx
	mov al,[bx]
	xor ah,ah
	mov dl,3
	div dl
	mov cx,ax
	mov bx,offset grid_resolution
	mov dl,[bx]
	mul dl
	push ax ;save y offset
	
	;choose column from the index
	mov ax,cx
	xchg ah,al
	xor ah,ah
	mul dl
	mov bx,offset left_shoulder_limit
	xor dh,dh
	mov dl,[bx]
	add ax,dx
	push ax ;save x offset
	
	;restore coordinates
	pop ax ;x coordinate in ax
	pop dx ;y coordinate in dx
	;update cow coordinates
	mov [cow_x],ax
	mov [cow_y],dx
	pop bx

	mov cx,[cow_h]
print_image_rows_cow:
		push cx
		
		push ax ;x coordinate in ax
		push dx ;y coordinate in dx
		;read one line from the file
		mov ah,3fh
		mov cx,[cow_w]
		mov dx,offset ScrLine
		int 21h
		pop dx
		mov ax,dx
		mov di,dx
		shl dx,6
		shl di,8
		add di,dx
		mov dx,ax
		pop ax
		add di,ax
		push ax
		push dx
		;copy to the screen buffer
		push es
		push bx
		
		mov bx,offset ScreenUnderUpdate
		mov ax,[bx]
		cmp ax,1
		je update_first_screen_cow
		mov ax, second_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
		jmp cont_update_cow
	update_first_screen_cow:
		mov ax, first_moving_screen
		mov es, ax
		ASSUME es:second_moving_screen
	cont_update_cow:
		mov bx,offset ScrLine
		xor si,si
		mov cx,[cow_w]
		copy_line_cow:
			mov al,[byte bx+si]
			;do not print background pixels
			cmp al,transparent_color_code
			je loop_cont_cow
			mov [es:[di]],al
			loop_cont_cow:
			inc si
			inc di
			loop copy_line_cow

		pop bx
		pop es
		pop dx
		inc dx
		pop ax
		pop cx
		loop print_image_rows_cow

	;close file
	macro_close_file cow_fhandle

	ret
endp print_cow
;-------------------------------------------
proc draw_pixel
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	
	mov al,[bp+6]  ;color
	mov ah,0Ch
	mov bx,0h
	mov dx,[bp+8]  ;y
	mov cx,[bp+10] ;x
	int 10h

	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
endp draw_pixel
;-------------------------------------------
proc draw_rectangle
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx

	mov al,[bp+10] ;color
	mov ah,0Ch
	mov dx,[bp+12] ;y left corner
	mov bx,[bp+14] ;x left corner
	
	mov cx,[bp+6] ;height
	row:
		push cx ;save loop counter
		mov cx,[bp+8] ;width
		col:
			push cx ;save loop counter
			push bx ;x
			push dx ;y
			push ax ; color
			call draw_pixel
			inc bx
			pop cx
			loop col
		
		mov bx,[bp+14] ;return to x left corner
		inc dx
		pop cx
		loop row

	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 10
endp draw_rectangle
;-------------------------------------------
proc draw_player
;--car main body------------
	push ax
	mov ax, [car_middle_axis_x]
	sub ax, 10
	macro_draw_rectange ax [car_start_row] [car_main_color] [car_width] [car_height]

;--top_left_wheel------------
	mov ax, [car_middle_axis_x]
	sub ax, 14
	macro_draw_rectange ax [car_start_row] 0 4 5

;--top_right_wheel--------------
    mov ax, [car_middle_axis_x]
	add ax, 5
	macro_draw_rectange ax [car_start_row] 0 4 5

;--bottom_right_wheel--------------
    mov ax, [car_middle_axis_x]
	add ax, 5
	macro_draw_rectange ax 190 0 4 5

;--top_left_wheel------------
	mov ax, [car_middle_axis_x]
	sub ax, 14
	macro_draw_rectange ax 190 0 4 5

;--car_top_part1------------
	mov ax, [car_middle_axis_x]
	sub ax, 9
	macro_draw_rectange ax 168 [car_main_color] 13 2

;--car_top_part2------------
	mov ax, [car_middle_axis_x]
	sub ax, 6
	macro_draw_rectange ax 166 [car_main_color] 7 2

;--window------------
	mov ax, [car_middle_axis_x]
	sub ax, 7
	macro_draw_rectange ax 172 0 9 2

	pop ax
	ret
endp draw_player
;-------------------------------------------
proc ReadHeaderMain
	; Read BMP file header, 54 bytes
	mov ah,3fh
	mov bx,[filehandleMain]
	mov cx,54
	mov dx,offset Header
	int 21h
	ret
endp ReadHeaderMain
;-------------------------------------------
proc ReadHeaderBG
	; Read BMP file header, 54 bytes
	mov ah,3fh
	mov bx,[filehandleBackGround]
	mov cx,54
	mov dx,offset Header
	int 21h
	ret
endp ReadHeaderBG
;---------------------------------------------------
proc CopyBitmapToMemory
	push es
	mov ax, empty_background_screen
	mov es, ax
	ASSUME es:empty_background_screen

	xor si,si
	mov cx,200
	PrintBMPLoop :
		push cx
		; di = cx*320, point to the correct screen line
		mov di,cx
		shl cx,6
		shl di,8
		add di,cx
		; Read one line
		mov ah,3fh
		mov cx,320
		mov dx,offset ScrLine
		int 21h

		mov bx, offset ScrLine
		mov cx,160
		Copy320:
			mov ax,[bx]
			mov [es:[si]], ax
			add bx,2
			add si,2
			loop Copy320
		pop cx
		loop PrintBMPLoop

	pop es
	ret
endp CopyBitmapToMemory
;----------------------------------------------------------------
proc ResetBackground
	; save ds, and es
	push ds
	push es

	mov bx,offset ScreenUnderUpdate
	mov ax,[bx]
	cmp ax,2
	je update_second_screen
	; take pointer to the reset buffer
	mov ax, first_moving_screen
	mov ds, ax
	ASSUME ds:first_moving_screen
	jmp goto_original_screen
update_second_screen:
	; take pointer to the reset buffer
	mov ax, second_moving_screen
	mov ds, ax
	ASSUME ds:second_moving_screen

goto_original_screen:
	; take pointer to the original buffer
	mov ax, empty_background_screen
	mov es, ax
	ASSUME es:empty_background_screen

	; copy entire buffer
	xor di,di
	xor si,si
	mov cx,32000 ; 320*200/2 - div by 2, becuse writing words
	copy_background_buffer:
		mov ax,[es:[si]]
		mov [ds:[di]],ax
		add di,2
		add si,2
		loop copy_background_buffer

	pop es
	pop ds
ret
endp ResetBackground
;----------------------------------------------------------------
proc ShowMainMenu
	push offset ErrorMsg
	push offset filehandleMain
	push offset filenameMain
	call OpenFile
	call ReadHeaderMain
	call ReadPalette
	call CopyPal

	;copy bitmap to screen
	; BMP graphics are saved upside-down .
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	mov ax,0A000h
	mov es,ax
	mov cx,200
	PrintBMPLoopMain:
		push cx
		; di = cx*320, point to the correct screen line
		mov di,cx
		shl cx,6
		shl di,8
		add di,cx
		; Read one line
		mov ah,3fh
		mov cx,320
		mov dx,offset ScrLine
		int 21h
		; Copy one line into video memory
		cld ; Clear direction flag, for movsb
		mov cx,320
		mov si,offset ScrLine
		rep movsb ; Copy line to the screen
		pop cx
		loop PrintBMPLoopMain

;	macro_close_file filehandleMain
	ret
endp ShowMainMenu
;----------------------------------------------------------------
proc draw_white_lines
	push es
	mov ax, empty_background_screen
	mov es, ax
	ASSUME es:empty_background_screen
	mov ah,255 ; white color code

	;-line1--------------
	mov cx,40
	build_rows1:
		push cx
		; di = cx*320, point to the correct screen line
		mov di,cx
		shl cx,6
		shl di,8
		add di,cx
		add di,150
		mov cx,10	; width
		build_cols1:
			mov [es:[di]],ah
			inc di
			loop build_cols1
		pop cx
	loop build_rows1
	
	;-line2--------------
	mov cx,40
	build_rows2:
		push cx
		; di = cx*320, point to the correct screen line
		mov di,cx
		shl cx,6
		add di,85
		shl di,8
		add di,cx
		add di,150
		mov cx,10	; width
		build_cols2:
			mov [es:[di]],ah
			inc di
			loop build_cols2
		pop cx
	loop build_rows2
	
	;-line3--------------
	mov cx,40
	build_rows3:
		push cx
		; di = cx*320, point to the correct screen line
		mov di,cx
		shl cx,6
		add di,170
		shl di,8
		add di,cx
		add di,150
		mov cx,10	; width
		build_cols3:
			mov [es:[di]],ah
			inc di
			loop build_cols3
		pop cx
	loop build_rows3
	
	pop es
	ret
endp draw_white_lines
;----------------------------------------------------------------
proc copy_one_line_into_video_memory
	mov ax,0A000h
	mov es,ax
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov di,dx
	mov cx,320
	mov si,offset ScrLine
	rep movsb ; Copy line to the screen
endp copy_one_line_into_video_memory
;----------------------------------------------------------------
proc check_for_collision
	mov bx,offset car_middle_axis_x
	mov si,[bx]
	mov bx,offset car_width
	mov cx,[bx]
	sub si,10 ;here is the left upper corner of the car, as it starts at 'draw_player'
	xor di,di ;di = 0 - will indicate collision if di > 0
	mov bx,offset ScrLine
	check_overlap_pixels:
		mov al,0FFh;white
		cmp [bx+si],al			
		je cont_check_overlap_pixels
		mov al,0F7h;asphalt grey
		cmp [bx+si],al 
		je cont_check_overlap_pixels
		inc di
		cont_check_overlap_pixels:
		inc si
		loop check_overlap_pixels
	
	ret
endp check_for_collision
;----------------------------------------------------------------
proc collision_alert
	;do not count if there was a recent collision
	mov bx,offset collision_alerted_counter
	mov ax,[bx]
	cmp ax,0
	ja continue_play
	;!!!! collision detected !!!!
	push bx
	call fail_sound ;play fail sound
	pop bx
	mov ax,1;indicate recent collision
	mov [bx],ax
	mov bx,offset lives
	mov ax,[bx]
	dec ax ;decrement 'lives'
	mov [bx],ax
	cmp ax,0
	je game_over
	jmp continue_play
	
game_over:
	jmp game_loss

continue_play:
	ret
endp collision_alert
;----------------------------------------------------------------
proc MoveScreen
	push es
	
	;choose which screen goes first
	mov bx,offset ScreenUnderUpdate
	mov ax,[bx]
	cmp ax,1
	je second_screen_first
	mov ax,first_moving_screen
	mov es,ax
	ASSUME es:first_moving_screen
	mov bx,offset FirstScreenOffset
	mov ax,[bx]
	mov bx,offset CurrentScreenOffset
	mov [bx],ax
	jmp goto_move_first_screen
second_screen_first:
	mov ax,second_moving_screen
	mov es,ax
	ASSUME es:second_moving_screen
	mov bx,offset SecondScreenOffset
	mov ax,[bx]
	mov bx,offset CurrentScreenOffset
	mov [bx],ax

goto_move_first_screen:	
	; treat the first screen
	xor si,si
	mov bx,offset CurrentScreenOffset
	mov dx,320*200
	mov cx,[bx]
	cmp cx,0
	jbe goto_move_second_screen
	first_screen:
		push cx
		mov ax,200
		sub ax,cx
		mov si,ax
		shl ax,6
		shl si,8
		add si,ax

		; copy from far memory buffer
		mov bx,offset ScrLine
		xor di,di
		mov cx,160
		copy_pixels1:
			mov ax,[es:[si]]
			mov [bx+di],ax
			add di,2
			add si,2
			loop copy_pixels1

		push es
		push si
		call copy_one_line_into_video_memory
		sub dx,320

		pop si
		pop es
		pop cx
		
		;print player every N(depends on the current 'gear') refreshes for smoother display
		;set the update speed according to the gear
		mov bx,offset gear
		mov al,[bx]
		dec al ;zero-based
		mov bx,offset gear_lut
		xlat ;get the value from the LUT in 'al'
		mov bl,al
		mov ax,cx
		div bl
		cmp ah,0
		jne cont1
		call draw_player
		
	cont1:
		;check for collision
		push cx
		push si
		mov ax,54400 ;check if the row counter is still above row n'170
		cmp dx,ax
		jb stop_check_collision1
		call check_for_collision
		;di > 0 - will indicate collision, take some spare (1)
		cmp di,1
		jbe stop_check_collision1
		call collision_alert
		
		stop_check_collision1:	
		pop si		
		pop cx
		
	loop first_screen

goto_move_second_screen:
	;now choose which screen goes second
	mov bx,offset ScreenUnderUpdate
	mov ax,[bx]
	cmp ax,1
	je other_screen_first1
	mov ax, second_moving_screen
	mov es, ax
	ASSUME es:second_moving_screen
	mov bx,offset SecondScreenOffset
	mov ax,[bx]
	mov bx,offset CurrentScreenOffset
	mov [bx],ax
	jmp goto_move_screen
other_screen_first1:
	mov ax, first_moving_screen
	mov es, ax
	ASSUME es:second_moving_screen
	mov bx,offset FirstScreenOffset
	mov ax,[bx]
	mov bx,offset CurrentScreenOffset
	mov [bx],ax

goto_move_screen:
	; treat the second screen
	xor si,si
	mov bx,offset CurrentScreenOffset
	mov cx,[bx]
	cmp cx,0
	jle continue1
	second_screen:
		push cx
		
		; copy from far memory buffer
		mov bx,offset ScrLine
		xor di,di
		mov cx,160
		copy_pixels2:
			mov ax,[es:[si]]
			mov [bx+di],ax
			add di,2
			add si,2
			loop copy_pixels2

		push es
		mov ax,0A000h
		mov es,ax
		; Copy one line into video memory
		cld ; Clear direction flag, for movsb
		mov di,dx
		mov cx,320
		push si
		mov si,offset ScrLine
		rep movsb ; Copy line to the screen
		sub dx,320

		pop si
		pop es
		pop cx
		
		;print player every N(depends on the current 'gear') refreshes for smoother display
		;set the update speed according to the gear
		mov bx,offset gear
		mov al,[bx]
		dec al ;zero-based
		mov bx,offset gear_lut
		xlat ;get the value from the LUT in 'al'
		mov bl,al
		mov ax,cx
		div bl
		cmp ah,0
		jne cont2
		call draw_player
		
	cont2:
		;check for collision
		push cx
		push si
		mov ax,54400 ;check if the row counter is still above row n'170
		cmp dx,ax
		jb stop_check_collision2
		call check_for_collision
		;di > 0 - will indicate collision, take some spare (1)
		cmp di,1
		jbe stop_check_collision2
		call collision_alert

		stop_check_collision2:
		pop si
		pop cx
		
	loop second_screen

continue1:
	;choose which offset to update
	mov bx,offset ScreenUnderUpdate
	mov ax,[bx]
	cmp ax,1
	jne offset1
	;decrement second screen offset and save
	mov bx,offset SecondScreenOffset
	mov ax,[bx]
	dec ax
	mov [bx],ax
	;increment first screen offset and save
	mov bx,offset FirstScreenOffset
	mov ax,[bx]
	inc ax
	mov [bx],ax
	;and exit
	jmp exit_move_screen
	
offset1:
	; decrement first screen offset and save
	mov bx,offset FirstScreenOffset
	mov ax,[bx]
	dec ax
	mov [bx],ax
	; increment second screen offset and save
	mov bx,offset SecondScreenOffset
	mov ax,[bx]
	inc ax
	mov [bx],ax

exit_move_screen:
	pop es
	ret
endp MoveScreen
;----------------------------------------------------------------
proc choose_trees_locations
	mov bx,offset trees_square_location_triplets_len
	mov al,[bx]
	mov bx,offset rnd_limit
	mov [bx],al ;set rand limit
	call get_random_number
	mov bx,offset rnd_number
	mov ax,[bx]
	mov bl,3 ;only 3 trees
	mul bl
	mov bx,offset trees_square_location_triplets
	add bx,ax
	push bx
	
	;choose a square for the small tree
	mov bx,offset rnd_limit
	mov al,3
	mov [bx],al
	call get_random_number
	mov bx,offset rnd_number
	mov si,[bx]
	pop bx
	mov al,[bx+si]
	push bx
	mov bx,offset stree_square_idx
	mov [bx],al
	
	;choose a square for the medium tree
	mov ax,si
	inc ax
	mov dl,3
	div dl
	xchg ah,al
	xor ah,ah
	mov si,ax
	pop bx
	mov al,[bx+si]
	push bx
	mov bx,offset mtree_square_idx 
	mov [bx],al
	
	;choose a square for the large tree
	inc si
	mov ax,si
	mov dl,3
	div dl
	xchg ah,al
	xor ah,ah
	mov si,ax
	pop bx
	mov al,[bx+si]
	mov bx,offset ltree_square_idx
	mov [bx],al
	
	ret
endp choose_trees_locations
;----------------------------------------------------------------
proc choose_obstacles_locations
	;check if this is the first time here
	mov bx,offset current_obstacles_state
	mov al,0FFh
	cmp [bx],al
	je no_prev_state
	
	;calculate transition to the next screen if the prev state was already set
	mov bx,offset obstacles_square_location_triplets_len
	mov ax,[bx]
	inc ax ;there is one more (first) column for the length indication
	mov bx,offset current_obstacles_state
	mov dl,[bx]
	mul dl
	; calculate offset to the possible transitions table entry
	mov bx,offset obstacles_transition_table
	add bx,ax
	
	xor ah,ah ;only low byte is effective
	mov al,[bx] ;take length of the table
	push bx
	mov bx,offset rnd_limit
	mov [bx],al ;set rand limit
	call get_random_number
	mov bx,offset rnd_number
	mov ax,[bx]
	pop bx
	add bx,ax
	xor ah,ah ;only low byte is effective
	mov al,[bx] ;take the index
	jmp prev_state_set
	
no_prev_state:
	;calculate first state ever
	mov bx,offset obstacles_square_location_triplets_len
	mov al,[bx]
	mov bx,offset rnd_limit
	mov [bx],al ;set rand limit
	call get_random_number
	mov bx,offset rnd_number
	mov ax,[bx]
	mov bx,offset current_obstacles_state
prev_state_set:
	mov [bx],al ;store the current state of obstacles
	mov bl,3 ;only 3 obstacles
	mul bl
	mov bx,offset obstacles_square_location_triplets
	add bx,ax
	push bx
	
	;choose a square for the rock2p
	mov bx,offset rnd_limit
	mov al,3
	mov [bx],al
	call get_random_number
	mov bx,offset rnd_number
	mov si,[bx]
	pop bx
	mov al,[bx+si]
	push bx
	mov bx,offset rock2p_square_idx
	mov [bx],al
	
	;choose the square for the chicken
	mov ax,si
	inc ax
	mov dl,3
	div dl
	xchg ah,al
	xor ah,ah
	mov si,ax
	pop bx
	mov al,[bx+si]
	push bx
	mov bx,offset chicken_square_idx
	mov [bx],al
	
	;choose the square for the cow
	inc si
	mov ax,si
	mov dl,3
	div dl
	xchg ah,al
	xor ah,ah
	mov si,ax
	pop bx
	mov al,[bx+si]
	mov bx,offset cow_square_idx
	mov [bx],al
	ret
endp choose_obstacles_locations
;----------------------------------------------------------------
proc print_all_trees
	; choos random trees location
	call choose_trees_locations
	
	; print trees
	call print_stree
	call print_mtree
	call print_ltree
	ret
endp print_all_trees
;----------------------------------------------------------------
proc print_all_obstacles
	; chose random obstacles location
	call choose_obstacles_locations

	; print obstacles
	call print_rock2p
	call print_chicken
	call print_cow

	ret
endp print_all_obstacles
;----------------------------------------------------------------
start:
	mov ax, @data
	mov ds, ax
	
	;set initial parameters (to be able to start over)
	mov bx,offset lives
	mov [word ptr bx],3
	mov bx,offset gear
	mov [byte ptr bx],1
	mov bx,offset car_middle_axis_x
	mov [word ptr bx],160
	mov bx,offset collision_alerted_counter
	mov [word ptr bx],0
	mov bx,offset TimerTickCurrent
	mov [word ptr bx],0
	mov bx,offset FirstScreenOffset
	mov [word ptr bx],200
	mov bx,offset SecondScreenOffset
	mov [word ptr bx],0
	mov bx,offset CurrentScreenOffset
	mov [word ptr bx],0

	WaitForKey:
	call enter_graphic_mode
	call ShowMainMenu
	mov al,0
	mov ah,1
	int 21h
	cmp al,0Dh; ENTER
	je cont_loading
	cmp al,72h; r
	je print_rules
	cmp al,52h; R
	je print_rules
	cmp al,1Bh; ESC
	jne WaitForKey
	jmp exit
	
	print_rules:
	call exit_graphic_mode
	call rules
	check_again_for_enter:
	mov al,0
	mov ah,1
	int 21h
	cmp al,0Dh
	je WaitForKey
	jmp check_again_for_enter

cont_loading:
	; start the timer
	; wait for first change in timer
	mov ax,40h
	mov es,ax
	mov ax,[Clock]
	FirstTick :
		cmp ax,[Clock]
		je FirstTick
	mov ax,[Clock]
	mov bx,offset FirstClockTick
	mov [bx],ax

	;set random seed and init
	mov bx,offset FirstClockTick
	mov ax,[bx]
	mov bx,offset rnd_seed
	mov [bx],al
	mov bx,offset rnd_number
	mov [bx],ax

	;prepare background screen and 2 helper screens
	call enter_graphic_mode
	;prepare arguments for openfile
	push offset ErrorMsg
	push offset filehandleBackGround
	push offset filenameBackGround
	call OpenFile
	call ReadHeaderBG
	call ReadPalette
	call CopyPal
	call CopyBitmapToMemory
	call draw_white_lines
	macro_close_file filehandleBackGround
	
	;reset first screen buffer
	mov bx,offset ScreenUnderUpdate
	mov ax,1
	mov [bx],ax
	call ResetBackground
	call print_all_trees;print trees only, but no obstacles yet
	
	;reset second screen buffer
	mov bx,offset ScreenUnderUpdate
	mov ax,2
	mov [bx],ax
	call ResetBackground
	call print_all_trees	;print trees
	call print_all_obstacles;and obstacles

Forever:
	call set_gear
	call MoveScreen
	
	;update collision_alerted_counter
	mov bx,offset collision_alerted_counter
	mov ax,[bx]
	cmp ax,0
	je seed_trees_and_obstacles
	inc ax
	mov [bx],ax
	cmp ax,096h;spare lives for 150 lines
	jb seed_trees_and_obstacles
	mov ax,0
	mov [bx],ax
	
seed_trees_and_obstacles:
	;if it's time, then
	;seed new trees/obstacles on the screen under update
	mov bx,offset SecondScreenOffset
	mov ax,[bx]
	cmp ax,200
	jne check_for_update_other_screen
	mov bx,offset ScreenUnderUpdate
	mov ax,1
	mov [bx],ax
	call ResetBackground
	call print_all_trees
	call print_all_obstacles
	jmp update_score
	
check_for_update_other_screen:
	mov bx,offset FirstScreenOffset
	mov ax,[bx]
	cmp ax,200
	jne update_score
	mov bx,offset ScreenUnderUpdate
	mov ax,2
	mov [bx],ax
	call ResetBackground
	call print_all_trees
	call print_all_obstacles

update_score:
	; score treatment
	call print_score

	; check if key pressed
	mov ah,1
	int 16h
	jz check_collision
	; check which key is pressed
	mov ah,0
	int 16h
	; ESC
	cmp ah,1
	je exit
	
	; check for right key
	cmp ah,4Dh
	je right_key
	; check for left key
	cmp ah,4Bh
	je left_key
	jmp check_collision

	right_key:
		mov bx,offset car_middle_axis_x
		mov ax,[bx]
		cmp ax,220
		jge check_collision
		add ax,5
		mov [bx],ax
		jmp check_collision

	left_key:
		mov bx,offset car_middle_axis_x
		mov ax,[bx]
		cmp ax,105
		jle check_collision
		sub ax,5
		mov [bx],ax
		jmp check_collision
		
check_collision:
	jmp Forever

game_loss:
	WaitForKey_loss:
	call GameOverScreen
	mov al,0
	mov ah,1
	int 21h
	cmp al,0Dh;ENTER
	je start
	jmp game_loss

exit:
	call exit_graphic_mode
	mov ax,4C00h
	int 21h

END start
