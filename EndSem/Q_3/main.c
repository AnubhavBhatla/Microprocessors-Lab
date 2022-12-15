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
	unsigned char pass=0;
	
	int S_bal = 10000;
	int G_bal = 10000;
	int withdraw = 0;
	int n500 = 0;
	int n100 = 0;
	int n=0;
	int flag=0;
	
	char S_pass[5] = {'E','E','3','3','7'};
	char G_pass[5] = {'U','P','L','A','B'};
	
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
							transmit_string("Please enter password\r\n");
							pass = receive_char();
							password[4] = pass;
							pass = receive_char();
							password[3] = pass;
							pass = receive_char();
							password[2] = pass;
							pass = receive_char();
							password[1] = pass;
							pass = receive_char();
							password[0] = pass;
							
							if (password == S_pass){
								transmit_string("Account Holder: Sita\r\n");
								int_to_string(S_bal,S_str);
								transmit_string("Account Balance: ");
								transmit_string(S_str);
								transmit_string("\r\n");
								transmit_string("Enter Amount, in hundreds\r\n");
								w = receive_char();
								n = w - '0';
								withdraw = n*1000;
								w = receive_char();
								n = w - '0';
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
							}
							else{
								transmit_string("Incorrect Password\r\n");
								break;
							}
						case '2' :
							transmit_string("Please enter password\r\n");
							pass = receive_char();
							password[4] = pass;
							pass = receive_char();
							password[3] = pass;
							pass = receive_char();
							password[2] = pass;
							pass = receive_char();
							password[1] = pass;
							pass = receive_char();
							password[0] = pass;
						
							if (password == G_pass){
								transmit_string("Account Holder: Gita\r\n");
								int_to_string(G_bal,G_str);
								transmit_string("Account Balance: ");
								transmit_string(G_str);
								transmit_string("\r\n");
								transmit_string("Enter Amount, in hundreds\r\n");
								w = receive_char();
								n = w - '0';
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
							else{
								transmit_string("Incorrect Password\r\n");
								break;
							}
						default:
							transmit_string("No such account, please enter valid details\r\n");
							break;
					}
			}
    }
}


