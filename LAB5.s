    PRESERVE8
	THUMB
		      AREA     STACK, NOINIT, READWRITE
Stack_Mem          SPACE    1024
__initial_sp

             AREA       RESET, DATA,  READONLY
				 EXPORT __Vectors
__Vectors		 DCD    __initial_sp
                 DCD    Main
			AREA       MYCODE,CODE,  READONLY	
                 ENTRY
Main    PROC
	             LDR R9,=0xE000E100    ;my address
				 MOV R4,#10
				 MOV R1,#2             ;MY NUMBER
				 MOV R10,#0            ;THE COUNTER
MYLP
                 CMP R10,#10
				 BEQ PROGRESSDONE
				 MOV R2,#0             ;REVERSE NUMBER
				 MOV R0,R1             ;COPY OF NUMBER,USE TO REVERSE NUMBER
				 
REVERSE			                       
                 CMP     R0,#0         ;check if the reverse operation in completed
				 BEQ     ISDONE        ;reversing is done
                 udiv    r5, r0, r4    ;R5 IS QOUT  
                 mul     r6, r5, r4    ;QOUT=QOUT*10=>TO calculate the remain 
                 sub     r7, r0, r6    ;R7 IS REMAIN 
				 
				 MOV     R0,R5         ;mov QOUT to R0
				 
				 MUL     R2,R2,R4      ;REVERSE*10
				 ADD     R2,R2,R7      ;REVERSE+REMAIN
				 B       REVERSE
				 
ISDONE				
                 CMP     R2,R1         ;CHECK IF THE NUMBER IS PALINDROME
				 BEQ     ISPALINDROME  ;JUMP TO DO ANOTHER TASK
				 ADD     R1,R1,#1      ;GO TO NEXT NUMBER
				 MOV     R0,R1         ;MOV NEW NUMBER IN R0
				 B       MYLP

ISPALINDROME

                 CMP     R2,#1         ;CHECK IF THE NUMBER IS 1 , IT IS NOT PRIME
				 BEQ     ISNOTPRIME
				 CMP     R2,#2         ;CHECK IF THE NUMBER IS 2, IT IS PRIME
                 BEQ     ISPRIME
				 MOV     R8,#2         ;CHECK IF THE NUMBER IS EVEN, IT IS NOT PRIME
				 udiv    r5, r2, R8    ;R5 IS QOUT  
                 mul     r6, r5, r8      
                 sub     r7, r2, r6    ;R7 IS REMAIN 
                 CMP     R7,#0
				 BEQ     ISNOTPRIME
				 ADD     R8,R8,#1      ;ADD 1 TO DIVIDOR NUMBER
PRIMECHECKER
                 CMP     R2,R8         ;CHECK IF ITERATOR IS EQUAL TO NUMBER, NUMBER IS PRIME
				 BEQ     ISPRIME
                 udiv    r5, r2, R8    ;DIVIDE THE NUMBER TO ITERATOR, R8
                 mul     r6, r5, r8      
                 sub     r7, r2, r6    ;R7 IS REMAIN 
                 CMP     R7,#0         ;IF THE REMAIN IS 0, IT IS NOT PRIME
				 BEQ     ISNOTPRIME
				 ADD     R8,R8,#2      ;GO TO NEXT ODD ITERATOR
				 B       PRIMECHECKER

ISNOTPRIME
                 ADD R1,R1,#1          ;GO TO NEXT NUMBER
				 B   MYLP 

ISPRIME
				 str R2,[R9]           ;SAVE THE NUMBER IN MEMORY
				 ADD R9,R9,#0x4        ;ADD 4 TO ADDRESS FOR NEXT WORD
                 ADD R1,R1,#1          ;GO TO NEXT NUMBER
				 ADD R10,R10,#1        ;ADD 1 TO COUNTER OF PRIME AND PLANDROME NUMBERS THAT FOUND
				 B   MYLP
PROGRESSDONE				 
                 
LOOP1            B    LOOP1
                 ENDP		  
	             END