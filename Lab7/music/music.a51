; This subroutine writes characters on the LCD

LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable



org 0000h
ljmp start

org 000bh
cpl P0.7
mov th0,30h
mov tl0,31h
reti

org 30h

start:
      mov P2,#00h
      mov P1,#00h
	  
	  ;initial delay for lcd power up
	;here1:setb p1.0
      	  acall delay
	;clr p1.0
	  acall delay
	;sjmp here1

	  acall lcd_init      ;initialise LCD
	  acall delay
	  acall delay
	  acall delay
	  
;---------------------------Start-----------------------------------------------------------------------
	  
	  ;-------------printing 1st row---------------
	  
	  mov a,#82h		 
	  acall lcd_command	
	  acall delay

	  mov   dptr,#s0_1   
	  acall lcd_sendstring	
	  acall delay
	  
	  loop : 
	  
	  mov tmod,#00010001b
	  mov ie,#82h
	  
	  ;----------------------N1------------------------
	  
	  mov 30h,#0EEH
	  mov 31h,#3FH
	  
	  mov th0,30h
	  mov tl0,31h
	  setb tr0
	  
	  mov r2,#30
	  here : acall timer
	  djnz r2,here
	  clr tr0
	  
	  ;----------------------N2------------------------
	  
	  mov 30h,#0F0H
	  mov 31h,#2FH
	  
	  mov th0,30h
	  mov tl0,31h
	  setb tr0
	  
	  mov r2,#30
	  here2 : acall timer
	  djnz r2,here2
	  clr tr0
	  
	  ;----------------------N3------------------------
	  
	  mov 30h,#0F2H
	  mov 31h,#0B7H
	  
	  mov th0,30h
	  mov tl0,31h
	  setb tr0
	  
	  mov r2,#30
	  here3 : acall timer
	  djnz r2,here3
	  clr tr0
	  
	  ;----------------------N2------------------------
	  
	  mov 30h,#0F0H
	  mov 31h,#2FH
	  
	  mov th0,30h
	  mov tl0,31h
	  setb tr0
	  
	  mov r2,#30
	  here4 : acall timer
	  djnz r2,here4
	  clr tr0
	  
	  ;----------------------N4------------------------
	  
	  mov 30h,#0F5H
	  mov 31h,#71H
	  
	  mov th0,30h
	  mov tl0,31h
	  setb tr0
	  
	  mov r2,#40
	  here5 : acall timer
	  djnz r2,here5
	  clr tr0
	  
	  ;-------------------Silence--------------------
	  
	  clr P0.7
	  
	  mov r2,#20
	  here6 : acall timer
	  djnz r2,here6
	  clr tr0
	  
	  ;----------------------N4------------------------
	  
	  mov 30h,#0F5H
	  mov 31h,#71H
	  
	  mov th0,30h
	  mov tl0,31h
	  setb tr0
	  
	  mov r2,#40
	  here7 : acall timer
	  djnz r2,here7
	  clr tr0
	  
	  ;----------------------N5------------------------
	  
	  mov 30h,#0F4H
	  mov 31h,#2AH
	  
	  mov th0,30h
	  mov tl0,31h
	  setb tr0
	  
	  mov r2,#40
	  here8 : acall timer
	  djnz r2,here8
	  clr tr0
	  
	  ;-----------repeating steps-----------------
	  ljmp loop
	  

org 400h
	
;-------------------------------delay of 25ms using Timer 1-------------------------------------

timer:

	MOV TL1,#0B0H
	MOV TH1,#3CH
	SETB TR1
	AGAIN : JNB TF1, AGAIN
	CLR TR1
	CLR TF1
	RET
	
	
;-------------------------------convert--------------------------------------------------------------

CONVERT:

	MOV A,R1
	ANL A,#0FH
	MOV R2,A
	ACALL CHECK
	MOV R3,A
	
	MOV A,R1
	ANL A,#0F0H
	SWAP A
	MOV R2,A
	ACALL CHECK
	MOV R4,A

	RET

	CHECK:

	CLR C
	SUBB A,#0AH
	JC NUM
	ADD A,#41H
	LABEL1 : RET
	NUM :
	MOV A,R2
	ADD A,#30H
	SJMP LABEL1
	
	
;------------------------LCD Initialisation routine----------------------------------------------------

lcd_init:

         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay

         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
		 
         clr   LCD_en
		 acall delay

         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay

         clr   LCD_en
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay

         clr   LCD_en
		 acall delay

         ret                  ;Return from routine


;-----------------------command sending routine-------------------------------------

 lcd_command:

         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
		 
         clr   LCD_en
		 acall delay

         ret  


;-----------------------data sending routine-------------------------------------		     

 lcd_senddata:

         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay

         clr   LCD_en
         acall delay
		 acall delay

         ret                  ;Return from busy routine


;-----------------------text strings sending routine-------------------------------------

lcd_sendstring:

	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero

	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer

	         sjmp  LCD_sendstring_loop    ;jump back to send the next character

exit:    pop 0e0h
         ret                     ;End of routine


;----------------------delay routine-----------------------------------------------------

delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret
	 
	 
;-------------------------delay for 1s-----------------------------------------------------------
	 
delay_1s:

	PUSH 00H
	MOV R0, #200
	H3: ACALL delay_5ms
	DJNZ R0, H3
	POP 00H
	RET

delay_5ms:

	PUSH 00H
	MOV R0, #20
	H2: ACALL delay_250us
	DJNZ R0, H2
	POP 00H
	RET

delay_250us:

	PUSH 00H
	MOV R0, #244
	H1: DJNZ R0, H1
	POP 00H
	RET
	

;------------- ROM text strings---------------------------------------------------------------

org 900h

s0_1:
         DB   "ROLLING TIME", 00H

end

