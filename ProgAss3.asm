TITLE Integer Accumulator     (ProgAss3.asm)

; Author: Frank Eslami
; Course / Project ID: CS 271-400 / Programming Assignment #3                 Date: 10-31-2014
; Description: Obtain numbers from user until a negative number is entered. Display to user the sum, count, 
; and average of the non-negative integers.

INCLUDE Irvine32.inc

UPPER_LIMIT = 100             ;the upper limit of the user's integer input

.data
intro1			BYTE		"Welcome to the Integer Accumulator by Frank Eslami.", 0
intro2			BYTE		"What is your name? ", 0
intro3			BYTE		", greetings and welcome. Let's get started!", 0
obtainNumber		BYTE		"Please enter numbers less than or equal to 100. Enter a negative number when you are finished to see results.", 0
enterNum            BYTE      "Number = ",0
InvalidNumMess      BYTE      "That's an invalid number. Please enter an number between 0-100. Enter a negative number when you are finished to see results.", 0
showInputCounter    BYTE      "Numbers entered = ", 0
showSum             BYTE      "Sum = ", 0
showAverage         BYTE      "Average = ", 0
specialBye          BYTE      "You exited the program without entering any non-negative numbers.", 0
finalBye            BYTE      "Thank you for using the Integer Accumulator. Have a great day!", 0

buffer			BYTE		20 Dup(0)    
inputCounter        Dword     0              ;tracks the number of non-negative number inputs from the user
sum                 Dword     0              ;the sum of inputs
average             Dword     0              ;the average of inputs


.code
main PROC
;Introduction
mov		edx, OFFSET intro1				;introduce the program and programmer
call 	WriteString
call       Crlf
mov       edx, OFFSET intro2                 ;ask for the user's name
call      WriteString
mov		edx, OFFSET buffer		     	;store user's name
mov		ecx, SIZEOF buffer				
call	     ReadString
call      WriteString                        ;display user's name
mov       edx, OFFSET intro3                 ;greet user		
call      WriteString		 
call	     Crlf
call	     Crlf

;Obtain integers from user until negative integer is entered                    
mov		edx, OFFSET obtainNumber 	     ;provide instructions to user for integer entry
call      WriteString
call      Crlf
call      Crlf
mov       edx, OFFSET enterNum               ;prompt for integer entry
call      WriteString
call	     ReadInt

LoopInputStart:                              ;obtain valid integers from user until user exists the program
Validate:                                    ;validate input to be <= UPPER_LIMIT
cmp		eax, UPPER_LIMIT
jle		Valid                              ;integer input <= UPPER_LIMIT

InvalidNum:                                  ;if int input > UPPER_LIMIT warn user and ask for another integer
mov       edx, OFFSET InvalidNumMess         ;display to user that integer was invalid 
call      WriteString
call      Crlf
mov       edx, OFFSET enterNum               ;ask for the next integer or to exit the program
call      WriteString
call      ReadInt                            ;store new integer
jmp       Validate                           ;jmp to Validate the new integer

Valid:                                       ;if user input < 0 exit input loop, else push input to stack and ask for next input
cmp       eax, 0
jl        LoopInputEnd                       ;if user input < 0 exit input loop
push      eax                                ;push integer to runtime stack
inc       inputCounter                       ;increment the number of inputs by the user by 1
mov       edx, OFFSET enterNum               ;ask for the next integer or to exit the program
call      WriteString
call      ReadInt
jmp       Validate                           ;validate new integer 

LoopInputEnd:                                ;end input loop

;If no non-negative numbers were added display a special message. Otherwise, display results
cmp       inputCounter, 0                    ;is input counter = 0?
jne       Calculations                       ;if non-negative numbers were entered display results

SpecialGoodbye:                              ;if no non-negative numbers were entered say this goodbye
mov       edx, OFFSET specialBye  
call      WriteString
call      CrLf
jmp       SayBye

Calculations:                                ;if non-negative numbers were entered, proceed with calculations
LoopSumBegin:                                ;beging loop to pop stack for sum calculation
mov       ecx, inputCounter                  ;set loop counter to the number of inputs
mov       eax, 0                             ;eax is the sum of all the stack pops, so set to zero to start with

LoopSum:                                     ;loop until all of the numbers in the running stack are popped and added to eax
pop       sum
add       eax, sum                                                         
loop      LoopSum
mov       sum, eax                           ;mov sum calculation in eax to sum
LoopSumEnd:

;calculate the average
mov       eax, sum                           ;move divident to eax
mov       edx, 0                             ;set edx to zero to make room for overflow
div       inputCounter                       ;divisor
mov       average, eax                      

;Display the results
call      CrLf
mov       edx, OFFSET showInputCounter       ;message for count total
call      WriteString
mov       eax, inputCounter                  ;count of user numbers entered
call      WriteDec
call      Crlf
mov       edx, OFFSET showSum                ;message for sum
call      WriteString
mov       eax, sum                           ;sum of numbers
call      WriteDec
call      CrLf
mov       edx, OFFSET showAverage            ;message for average
call      WriteString
mov       eax, average                       ;average of numbers
call      WriteDec
call      CrLf
call      CrLf

SayBye:                                      ;say final goodbye and exit program
mov       edx, OFFSET finalBye               
call      WriteString
call      CrLf
      

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
