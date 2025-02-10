
DATA SEGMENT
; Messages
    msg_min DB 0ah,0dh , "Enter the minimum value: $"
    msg_max DB 0ah,0dh, "Enter the maximum value: $" 
    
    msg_guess1 DB 0ah,0dh, "Is your number $" 
    msg_guess2 DB          " ?(C=Correct, H=Higher, L=Lower): $"    
    
    msg_correct1 DB 0ah,0dh, "Guessed your number in $"
    msg_correct2 DB          " attempts!$"   
     
    num_error DB 0ah,0dh, "Invalid input, enter MIN less than MAX$"
    char_error DB 0ah,0dh, "Invalid input, Please enter 'C', 'H', or 'L'.$"
    
    read_input DB 10 DUP('$')
    
    ; Variables
    min DW ?       ; Lower bound
    max DW ?       ; Upper bound
    mid DW ?       ; Midpoint
    attempts DW 0  ; Attempt counter
DATA ENDS

CODE SEGMENT 
    ASSUME CS:CODE, DS:DATA

START:
    ; Initialize data segment
    MOV AX, DATA
    MOV DS, AX

    ; Input minimum value
    LEA DX, msg_min
    MOV AH, 09H
    INT 21H 
    
    ;read                          
    CALL ReadNumber
    MOV min, CX

    ; Input maximum value
    LEA DX, msg_max
    MOV AH, 09H
    INT 21H
       
    ;read
    CALL ReadNumber
    MOV max, CX

    ; Ensure min < max 
     mov ax, min         
     ;mov bx, max 
     cmp ax,max
     Jl VALID_RANGE 
     
    ; If invalid range, loop until valid
    lea DX, num_error
    MOV AH, 09H
    INT 21H
    JMP START
                       
VALID_RANGE:
GUESS_LOOP:
    ; Increment attempts
    INC WORD PTR attempts
GUESS_LOOP2:
    ; Calculate midpoint: mid = (min + max) / 2
    MOV AX, min
    ADD AX, max
    SHR AX, 1
    MOV mid, AX
              
              
    ; Prompt user with guess
    LEA DX, msg_guess1
    MOV AH, 09H
    INT 21H   
          
    mov ax,mid    
    CALL PrintNumber
        
    LEA DX, msg_guess2
    MOV AH, 09H
    INT 21H
    
       
    ; Get user response
    CALL GetUserResponse
    CMP AL, 'c'  ; Correct
    JE CORRECT
    CMP AL, 'h'  ; Higher
    JE HIGHER
    CMP AL, 'l'  ; Lower
    JE LOWER

    ; Invalid input
    LEA DX, char_error
    MOV AH, 09H
    INT 21H
    JMP GUESS_LOOP2

HIGHER:
    ; Adjust min: min = mid + 1
    MOV AX, mid
    INC AX                         
    MOV min, AX
    JMP GUESS_LOOP

LOWER:
    ; Adjust max: max = mid - 1
    MOV AX, mid
    DEC AX
    MOV max, AX
    JMP GUESS_LOOP

CORRECT:  

    ; Display success message
    LEA DX, msg_correct1
    MOV AH, 09H
    INT 21H    
       
    mov ax,attempts   
    CALL PrintNumber
          
    LEA DX, msg_correct2
    MOV AH, 09H
    INT 21H  
    
    JMP END_PROGRAM 

END_PROGRAM:
    ; Exit program
    MOV AH, 4CH
    INT 21H
     
   ;Reading Number proc ---------------------->
   ; Subroutine: ReadNumber
   ; Reads a number from the user and stores it in AX
   ; Returns CF=1 on invalid input, CF=0 otherwise
    
ReadNumber PROC
    XOR BX, BX           ; Clear BX (to store the number)
    XOR AX, AX           ; Clear AX
    XOR CX, CX           ; clear cx
    XOR DX,DX
    MOV SI, 0            ; Input flag

    LEA DX, read_input
    MOV AH, 0Ah            
    INT 21h  
    
    XOR SI, SI              
    MOV SI, OFFSET read_input+2  
    XOR AL, AL              
    MOV CL, AL             
    
ConvertToInt:

    CMP BYTE PTR [SI], 0Dh
    JE complet             
    
   
    MOV AL, CL            
    MOV BL, 10            
    MUL BL                
    MOV CL, AL             
    
    XOR AX, AX
    ADD AL, [SI]           
    SUB AL, 30h             
    ADD CL, AL             
    
   
    INC SI
    JMP ConvertToInt 
    
    complet:
    RET
ReadNumber ENDP     

         
    ;Printing Number Proc---------------------->                      
                   
    ; Subroutine: PrintNumber
    ; Prints a number (AX) to the screen  
          
    
    PrintNumber PROC
        PUSH AX              ; Save AX
        PUSH BX              ; Save BX
        PUSH CX              ; Save CX
        MOV CX, 0            ; Digit count
    PRINT_LOOP:
        XOR DX, DX           ; Clear DX
        MOV BX, 10
        DIV BX               ; AX = AX / 10, DX = remainder
        PUSH DX              ; Store remainder on stack
        INC CX               ; Increment digit count
        TEST AX, AX          ; Check if AX is 0
        JNZ PRINT_LOOP
    PRINT_DIGITS:
        POP DX               ; Get a digit
        ADD DL, '0'          ; Convert to ASCII
        MOV AH, 02H          ; Print character
        INT 21H
        LOOP PRINT_DIGITS
        POP CX
        POP BX
        POP AX
        RET
    PrintNumber ENDP  
    
    
    
    ; Subroutine: GetUserResponse
    ; Waits for a key press and returns it in AL
    
    GetUserResponse PROC
        MOV AH, 01H          ; Wait for key press
        INT 21H
        RET
    GetUserResponse ENDP
    
    CODE ENDS
    END START
