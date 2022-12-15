; This subroutine writes characters on the LCD

LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable



ORG 0000H
ljmp start

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
	  
;---------------------------State 0-----------------------------------------------------------------------

	  mov a,#82h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay

	  mov   dptr,#s0_1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C3h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay

	  mov   dptr,#s0_2
	  acall lcd_sendstring
	  
	  acall delay_1s
	  
;----------------------------State 1-4----------------------------------------------------------------------
	  
	  mov a,#81h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay

	  mov   dptr,#s14_1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C3h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay

	  mov   dptr,#s14_2
	  acall lcd_sendstring
	  
	  mov P1,#0
	  setb P1.7
	  
	  acall delay_1s
	  acall delay_1s
	  
	  mov P1,#0ffh
	  mov a,P1
	  anl a,#0fh
	  swap a
	  mov 30h,a
	  
	  mov P1,#0
	  setb P1.6
	  
	  acall delay_1s
	  acall delay_1s
	  
	  mov P1,#0ffh
	  mov a,P1
	  anl a,#0fh
	  add a,30h
	  mov 30h,a
	  
	  mov P1,#0
	  setb P1.5
	  
	  acall delay_1s
	  acall delay_1s
	  
	  mov P1,#0ffh
	  mov a,P1
	  anl a,#0fh
	  swap a
	  mov 31h,a
	  
	  mov P1,#0
	  setb P1.4
	  
	  acall delay_1s
	  acall delay_1s
	  
	  mov P1,#0ffh
	  mov a,P1
	  anl a,#0fh
	  add a,31h
	  mov 31h,a
	  
	  clr P1.4
	  
	  
;---------------------------State 5--------------------------------------------------------------------------	  
	  
	  mov r1,#30h
	  acall convert
	  mov 61h,r3
	  mov 60h,r4
	  
	  mov r1,#31h
	  acall convert
	  mov 63h,r3
	  mov 62h,r4
	  
	  mov a,#80h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay

	  mov   dptr,#s5_1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C0h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay

	  mov   dptr,#s5_2
	  acall lcd_sendstring
	  
	  mov a,#0C5h
	  acall lcd_command
	  acall delay
	  
	  mov a,60h
	  acall lcd_senddata
	  acall delay
	  
	  mov a,#0C6h
	  acall lcd_command
	  acall delay
	  
	  mov a,61h
	  acall lcd_senddata
	  acall delay
	  
	  mov a,#0C7h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay

	  mov   dptr,#s5_3
	  acall lcd_sendstring
	  
	  mov a,#0Ceh
	  acall lcd_command
	  acall delay
	  
	  mov a,62h
	  acall lcd_senddata
	  acall delay
	  
	  mov a,#0Cfh
	  acall lcd_command
	  acall delay
	  
	  mov a,63h
	  acall lcd_senddata
	  acall delay
	  
	  acall delay_1s
	  acall delay_1s
	  
	  mov a,30h
	  mov b,31h
	  mul ab
	  
	  mov 32h,b
	  mov 33h,a
	  
	  mov r1,#32h
	  acall convert
	  mov 65h,r3
	  mov 64h,r4
	  
	  mov r1,#33h
	  acall convert
	  mov 67h,r3
	  mov 66h,r4
	  
	  mov a,#80h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay

	  mov   dptr,#s6_1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	  
	  mov a,#08ah
	  acall lcd_command
	  acall delay
	  
	  mov a,64h
	  acall lcd_senddata
	  acall delay
	  
	  mov a,#08bh
	  acall lcd_command
	  acall delay
	  
	  mov a,65h
	  acall lcd_senddata
	  acall delay
	  
	  mov a,#08ch
	  acall lcd_command
	  acall delay
	  
	  mov a,66h
	  acall lcd_senddata
	  acall delay
	  
	  mov a,#08dh
	  acall lcd_command
	  acall delay
	  
	  mov a,67h
	  acall lcd_senddata
	  acall delay
	  
	  mov a,#08eh
	  acall lcd_command
	  acall delay
	  
	  mov   dptr,#s6_2   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	  

here: sjmp here				//stay here 



;------------------------LCD Initialisation routine----------------------------------------------------

org 200h

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


;-------------------------------convert--------------------------------------------------------------

CONVERT:

	MOV A,@R1
	ANL A,#0FH
	MOV R2,A
	ACALL CHECK
	MOV R3,A
	
	MOV A,@R1
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
	
	
;------------- ROM text strings---------------------------------------------------------------

org 300h

s0_1:
         DB   "Enter Inputs", 00H

s0_2:
		 DB   "EE337-2022", 00H
			 
s14_1:
         DB   "Reading Inputs", 00H

s14_2:
		 DB   "EE337-2022", 00H
			 
s5_1:
         DB   "Computing Result", 00H

s5_2:
		DB   "Num1:", 00H
			
s5_3:
		DB   ", Num2:", 00H
			
s6_1:
         DB   " Result = ", 00H
			
s6_2:
		DB   "  ", 00H

end

