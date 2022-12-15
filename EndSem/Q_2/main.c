#include <at89c5131.h>
#include "endsem.h"

char S_str[6]= {0,0,0,0,0,0};   //String for Balance Sita
char G_str[6] = {0,0,0,0,0,0};  //String for Balance Gita
char n500_s[3]= {0,0,0};    // STRING FOR 500RS NOTE
char n100_s[3]= {0,0,0};    // STRING FOR 100RS NOTE

char password[5] = {0,0,0,0,0} ;   //PASSWORD ARRAY
//Main function

//-------------------------------------------------
void main(void)
{
	unsigned char state=0;
	unsigned char account=0;
	unsigned char w=0;
	
	int S_bal = 10000;
	int G_bal = 10000;
	int withdraw = 0;
	int n500 = 0;
	int n100 = 0;
	int n=0;
	int flag=0;
	
	uart_init();            // Please finish this function in endsem.h 
	transmit_string("Press A for Account display and W for withdrawing cash\r\n");
    while (1)
    {
        /* code */
        // YOUR CODE GOES HERE
			state = receive_char();
			if (state == 'w'){
				state = 'W';
			}
			if (state == 'a'){
				state = 'A';
			}
			switch(state)
			{
				case 'A' : 
					transmit_string("Hello, Please enter Account Number\r\n");
					account = receive_char();
					switch(account){
						case '1' : 
							transmit_string("Account Holder: Sita\r\n");
							int_to_string(S_bal,S_str);
							transmit_string("Account Balance: ");
							transmit_string(S_str);
							transmit_string("\r\n");
							break;
						case '2' :
							transmit_string("Account Holder: Gita\r\n");
							int_to_string(G_bal,G_str);
							transmit_string("Account Balance: ");
							transmit_string(G_str);
							transmit_string("\r\n");
							break;
						default:
							transmit_string("No such account, please enter valid details\r\n");
							break;
					}
					break;
				case 'W' : 
					transmit_string("Hello, Please enter Account Number\r\n");
					account = receive_char();
					switch(account){
						case '1' : 
							transmit_string("Account Holder: Sita\r\n");
							int_to_string(S_bal,S_str);
							transmit_string("Account Balance: ");
							transmit_string(S_str);
							transmit_string("\r\n");
							transmit_string("Enter Amount, in hundreds\r\n");
							w = receive_char();
							switch(w){
								case '0' :
									n=0;
									break;
								case '1' :
									n=1;
									break;
								case '2' :
									n=2;
									break;
								case '3' :
									n=3;
									break;
								case '4' :
									n=4;
									break;
								case '5' :
									n=5;
									break;
								case '6' :
									n=6;
									break;
								case '7' :
									n=7;
									break;
								case '8' :
									n=8;
									break;
								case '9' :
									n=9;
									break;
								default :
									transmit_string("Invalid Amount\r\n");			
									flag = 1;
									break;
							}
							if (flag == 1){
								break;
							}
							withdraw = n*1000;
							w = receive_char();
							switch(w){
								case '0' :
									n=0;
									break;
								case '1' :
									n=1;
									break;
								case '2' :
									n=2;
									break;
								case '3' :
									n=3;
									break;
								case '4' :
									n=4;
									break;
								case '5' :
									n=5;
									break;
								case '6' :
									n=6;
									break;
								case '7' :
									n=7;
									break;
								case '8' :
									n=8;
									break;
								case '9' :
									n=9;
									break;
								default :
									transmit_string("Invalid Amount\r\n");	
									flag = 1;
									break;
							}
							if (flag == 1){
								break;
							}
							withdraw = withdraw + n*100;
							if(withdraw < S_bal){
								S_bal = S_bal - withdraw;
								int_to_string(S_bal,S_str);
								transmit_string("Remaining Balance: ");
								transmit_string(S_str);
								transmit_string("\r\n");
								n500 = withdraw/500;
								n100 = (withdraw - n500*500)/100;
								int_to_string_2(n500,n500_s);
								int_to_string_2(n100,n100_s);
								transmit_string("500 Notes: ");
								transmit_string(n500_s);
								transmit_string(", 100 Notes: ");
								transmit_string(n100_s);		
								transmit_string("\r\n");
							}
							else{
								transmit_string("Insufficient Funds\r\n");
							}
							break;
						case '2' :
							transmit_string("Account Holder: Gita\r\n");
							int_to_string(G_bal,G_str);
							transmit_string("Account Balance: ");
							transmit_string(G_str);
							transmit_string("\r\n");
							transmit_string("Enter Amount, in hundreds\r\n");
							w = receive_char();
							switch(w){
								case '0' :
									n=0;
									break;
								case '1' :
									n=1;
									break;
								case '2' :
									n=2;
									break;
								case '3' :
									n=3;
									break;
								case '4' :
									n=4;
									break;
								case '5' :
									n=5;
									break;
								case '6' :
									n=6;
									break;
								case '7' :
									n=7;
									break;
								case '8' :
									n=8;
									break;
								case '9' :
									n=9;
									break;
								default :
									transmit_string("Invalid Amount\r\n");			
									flag = 1;
									break;
							}
							withdraw = n*1000;
							w = receive_char();
							switch(w){
								case '0' :
									n=0;
									break;
								case '1' :
									n=1;
									break;
								case '2' :
									n=2;
									break;
								case '3' :
									n=3;
									break;
								case '4' :
									n=4;
									break;
								case '5' :
									n=5;
									break;
								case '6' :
									n=6;
									break;
								case '7' :
									n=7;
									break;
								case '8' :
									n=8;
									break;
								case '9' :
									n=9;
									break;
								default :
									transmit_string("Invalid Amount\r\n");	
									flag = 1;
									break;
							}
							withdraw = withdraw + n*100;
							if(withdraw < G_bal){
								G_bal = G_bal - withdraw;
								int_to_string(G_bal,G_str);
								transmit_string("Remaining Balance: ");
								transmit_string(G_str);
								transmit_string("\r\n");
								n500 = withdraw/500;
								n100 = (withdraw - n500*500)/100;
								int_to_string_2(n500,n500_s);
								int_to_string_2(n100,n100_s);
								transmit_string("500 Notes: ");
								transmit_string(n500_s);
								transmit_string(", 100 Notes: ");
								transmit_string(n100_s);		
								transmit_string("\r\n");
							}
							else{
								transmit_string("Insufficient Funds\r\n");
							}
							break;
						default:
							transmit_string("No such account, please enter valid details\r\n");
							break;
					}
			}
    }
}


