; This subroutine writes characters on the LCD

LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable


org 0000h
ljmp start

org 0003h
acall ext0_isr
reti

org 000bh
inc r5
clr tf0
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
	  
	  mov P1,#00
	  mov IE,#10000011b
	  
	  loop : 
	  
	  mov tmod,#01
	  mov tl0,#00h
	  mov th0,#00h
	  setb tcon.0
	  
	  mov r5,#0
	  
	  ;-------------printing 1st row---------------
	  
	  mov a,#80h		 
	  acall lcd_command	
	  acall delay

	  mov   dptr,#s0_1   
	  acall lcd_sendstring	
	  acall delay
	  
	  ;-------------printing 2nd row---------------

	  mov a,#0C0h	
	  acall lcd_command
	  acall delay

	  mov   dptr,#s0_2
	  acall lcd_sendstring
	  
	  ;------------------delay of 2s------------------
	  
	  acall delay_1s
	  acall delay_1s
	  
	  
;----------------------------Reaction Time---------------------------------------------------------
	  
	  ;------------LED turns on-------------------
      cpl P1.4
	  
		  
	  ;------------start timer-----------------------
	  clr tf0
	  setb tr0
	  
	  setb P1.0
	  here : clr c
	  mov c,P1.0
	  cpl c
	  mov P3.2,c
	  jc here
	  
	  ;---------converting to ASCII-------------
	  ;------------dividing by 2000---------------
	  mov 30h,r5
	  mov 31h,th0
	  mov 32h,tl0
	  
	  acall DIV2
	  acall DIV10
	  acall DIV10
	  acall DIV10
	  
	  acall DIV10
	  mov 61h,b
	  
	  acall DIV10
	  mov a,b
	  swap a
	  add a,61h
	  mov 61h,a
	  
	  acall DIV10
	  mov a,32h
	  swap a
	  add a,b
	  mov 60h,a
	  
	  mov r1,61h
	  acall convert
	  mov 63h,r3
	  mov 62h,r4
	  
	  mov r1,60h
	  acall convert
	  mov 61h,r3
	  mov 60h,r4
	  
	  
	  ;-------------printing 1st row---------------
	  
	  mov a,#80h		
	  acall lcd_command	
	  acall delay

	  mov   dptr,#s1_1   
	  acall lcd_sendstring	  
	  acall delay
	  
	  ;-------------printing 2nd row---------------
	  
	  ;------------------1st digit---------------------
	  mov a,#0C0h		
	  acall lcd_command
	  acall delay

	  mov  a,60h
	  acall lcd_senddata
	  acall delay
	  
	  ;------------------2nd digit---------------------
	  mov a,#0C1h		
	  acall lcd_command
	  acall delay

	  mov  a,61h
	  acall lcd_senddata
	  acall delay
	  
	  ;------------------3rd digit---------------------
	  mov a,#0C2h		
	  acall lcd_command
	  acall delay

	  mov  a,62h
	  acall lcd_senddata
	  acall delay
	  
	  ;------------------4th digit---------------------
	  mov a,#0C3h		
	  acall lcd_command
	  acall delay

	  mov  a,63h
	  acall lcd_senddata
	  acall delay
	  
	  ;----------remaining string-----------------
	  mov a,#0C4h		
	  acall lcd_command	
	  acall delay

	  mov   dptr,#s1_2   
	  acall lcd_sendstring	  
	  acall delay
	  
	  ;-------------------delay of 5s---------------
	  
	  acall delay_1s
	  acall delay_1s
	  acall delay_1s
	  acall delay_1s
	  acall delay_1s
	  
	  ;-----------repeating both steps---------
	  ljmp loop
	  

org 400h
	
;------------------------------External 0 ISR------------------------------------------------------------

ext0_isr:
    clr tr0
	clr P1.4
	clr c
	ret
	
;-----------------------------------Divide by 2------------------------------------------------------------

DIV2:
CLR C

MOV A,30H
RRC A
MOV 30H,A

MOV A,31H
RRC A
MOV 31H,A

MOV A,32H
RRC A
MOV 32H,A

RET

;-----------------------------------Divide by 10-----------------------------------------------------------

DIV10:
MOV A,30H
MOV B,#10
DIV AB

MOV 30H,A
MOV A,31H
ANL A,#0F0H
ADD A,B
SWAP A

MOV B,#10
DIV AB
SWAP A
MOV R6,A

MOV A,B
SWAP A
MOV B,A
MOV A,31H
ANL A,#0FH
ADD A,B

MOV B,#10
DIV AB
ADD A,R6
MOV 31H,A

MOV A,32H
ANL A,#0F0H
ADD A,B
SWAP A

MOV B,#10
DIV AB
SWAP A
MOV R7,A

MOV A,B
SWAP A
MOV B,A
MOV A,32H
ANL A,#0FH
ADD A,B

MOV B,#10
DIV AB
ADD A,R6
MOV 32H,A

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
         DB   "   Toggle SW1   ", 00H

s0_2:
		 DB   "  if LED glows  ", 00H
			 
s1_1:
         DB   "  Reaction Time ", 00H

s1_2:
		 DB   " millisecond", 00H

end

