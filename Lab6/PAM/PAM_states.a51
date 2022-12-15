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
	  
;-----------------------------Setting Up----------------------------------------------------------------
	  
	  mov 70h,#0F1h
	  mov 71h,#0D3h
	  
	  mov a,70h
	  anl a,#0fh
	  mov 73h,a
	  
	  mov a,70h
	  anl a,#0f0h
	  swap a
	  mov 72h,a
	  
	  mov a,71h
	  anl a,#0fh
	  mov 75h,a
	  
	  mov a,71h
	  anl a,#0f0h
	  swap a
	  mov 74h,a
	  
	  loop : 
;---------------------------State 1-----------------------------------------------------------------------
	  
	  mov a,73h
	  swap a
	  mov p1,a
	  
	  mov a,#85h		 
	  acall lcd_command	 
	  acall delay

	  mov   dptr,#s1   
	  acall lcd_sendstring	
	  acall delay

	  mov a,#0C3h		 
	  acall lcd_command
	  acall delay

	  mov   dptr,#s
	  acall lcd_sendstring
	  
	  mov a,73h
	  acall print
	  
	  acall delay_1s
	  
;---------------------------State 2-----------------------------------------------------------------------
	
	  mov a,72h
	  swap a
	  mov p1,a
	  
	  mov a,#85h		 
	  acall lcd_command	
	  acall delay

	  mov   dptr,#s2   
	  acall lcd_sendstring	
	  acall delay

	  mov a,#0C3h		 
	  acall lcd_command
	  acall delay

	  mov   dptr,#s
	  acall lcd_sendstring
	  
	  mov a,72h
	  acall print
	  
	  acall delay_1s
	  
;---------------------------State 3-----------------------------------------------------------------------
	  
	  mov a,75h
	  swap a
	  mov p1,a
	  
	  mov a,#85h		 
	  acall lcd_command	 
	  acall delay

	  mov   dptr,#s3   
	  acall lcd_sendstring
	  acall delay

	  mov a,#0C3h
	  acall lcd_command
	  acall delay

	  mov   dptr,#s
	  acall lcd_sendstring
	  
	  mov a,75h
	  acall print
	  
	  acall delay_1s

;---------------------------State 4-----------------------------------------------------------------------

	  mov a,74h
	  swap a
	  mov p1,a

	  mov a,#85h
	  acall lcd_command
	  acall delay

	  mov   dptr,#s4
	  acall lcd_sendstring
	  acall delay

	  mov a,#0C3h
	  acall lcd_command
	  acall delay

	  mov   dptr,#s
	  acall lcd_sendstring
	  
	  mov a,74h
	  acall print
	  
	  acall delay_1s
	  
;-------------------Repeat------------------
	  
	  ljmp loop			

;------------------------LCD Initialisation Routine----------------------------------------------------

org 400h

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


;-----------------------Command Sending Routine-------------------------------------

 lcd_command:

         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
		 
         clr   LCD_en
		 acall delay

         ret  

;-----------------------Data Sending Routine-------------------------------------		     

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



;-----------------------Text Strings Sending Routine-------------------------------------

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



;----------------------Delay Routine-----------------------------------------------------

delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret
	 
;-------------------------Delay for 1s-----------------------------------------------------------
	 
delay_1s:

	mov a,#0ffh
	subb a,#50h
	add a,#1
	mov 32h,a
	jc carry
	back : mov a,#0ffh
	subb a,#0c3h
	mov 31h,a
	
	mov r3,#1
	here : mov r2,#40
	here2 : acall timer
	djnz r2,here2
	djnz r3,here
	ret

timer:

	mov tmod,#01
	mov tl0,32H
	mov th0,31H
	setb tr0
	again: jnb tf0, again
	clr tr0
	clr tf0
	ret
	
carry :

	mov a,31h
	subb a,#1
	mov 31h,a
	ljmp back

;-------------------------------Convert--------------------------------------------------------------

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
	
	
;--------------------------------------------Print Level-------------------------------------------------

print:
;----------------1st bit-----------------
	  mov b,a
	  anl a,#01
	  mov r1,a
	  acall convert

	  mov a,#0CDH
	  acall lcd_command
	  acall delay

	  mov a,r3
	  acall lcd_senddata
	  acall delay

;----------------2nd bit-----------------
	  mov a,b
	  anl a,#02
	  rr a
	  mov r1,a
	  acall convert

	  mov a,#0CCH
	  acall lcd_command
	  acall delay

	  mov a,r3
	  acall lcd_senddata
	  acall delay
	  
;----------------3rd bit-----------------
	  mov a,b
	  anl a,#04
	  rr a
	  rr a
	  mov r1,a
	  acall convert

	  mov a,#0CBH
	  acall lcd_command
	  acall delay

	  mov a,r3
	  acall lcd_senddata
	  acall delay
	  
;----------------4th bit-----------------
	  mov a,b
	  anl a,#08
	  rr a
	  rr a
	  rr a
	  mov r1,a
	  acall convert

	  mov a,#0CAH
	  acall lcd_command
	  acall delay

	  mov a,r3
	  acall lcd_senddata
	  acall delay
	  
	  ret
	
	
;------------- ROM text strings---------------------------------------------------------------

org 900h

s1:
         DB   "Level 1", 00H
			 
s2:
         DB   "Level 2", 00H

s3:
         DB   "Level 3", 00H
			 
s4:
         DB   "Level 4", 00H

s:
		DB   "Value: ", 00H

end

