#include <at89c5131.h>
#include "lcd.h"				//Header file with LCD interfacing functions
#include "MorseCode.h"	//Header file for Morse Code 

sbit LED=P1^7;

/*
Port P0.7 is used for the audio signal output
*/
int value;
//Main function

void main(void)
{
		
	//Call initialization functions
	lcd_init();
	lcd_cmd(0x88);
	
	// Read input nibble here
	P1 = 0x0F ;
	value = P1;
	// Insert Priority Logic
	// Inside each condition, call the functions from MorseCode.h. Fill functions in MorseCode.h
	if (value%2) {
		lcd_write_char('A');
		morsea();
	}
	else if (value%4) {
		lcd_write_char('B');
		morseb();
	}
	else if (value%8) {
		lcd_write_char('C');
		morsec();
	}
	else if (value%16) {
		lcd_write_char('D');
		morsed();
	}
	else {
		lcd_write_char('E');
		morsee();
	}
	// Write to LCD using function lcd_write_string() in side the condition as well 
	while (1) {
	}
}
