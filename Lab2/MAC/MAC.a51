ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL MAC
HERE: SJMP HERE
ORG 130H
CLR A
MAC:
// MAC OPERATION, CALL THE ADDITION SUBROUTINE USING "CALL ADD16"
MOV A, 70H
MOV B, 73H
MUL AB
MOV R0, B
MOV R1, A
MOV A, 71H
MOV B, 74H
MUL AB
MOV R2, B
MOV R3, A
CALL ADD16
MOV A, 72H
MOV B, 75H
MUL AB
MOV R0, B
MOV R1, A
CALL ADD16
MOV 50H, R4
MOV 51H, R2
MOV 52H, R3
RET
ADD16:
MOV A,R1
ADD A,R3
MOV R3,A
MOV A,R0
ADDC A,R2
MOV R2, A
MOV A, R4
ADDC A, #00H
MOV R4, A
//JC cy_check
//cy_check: INC 74H
RET
END