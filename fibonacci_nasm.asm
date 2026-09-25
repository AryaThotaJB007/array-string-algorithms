; Fibonacci Number Generator
; Calculates the first seven Fibonacci numbers and stores them in a byte array
; Formula: Fib(1) = 1, Fib(2) = 1, Fib(n) = Fib(n-1) + Fib(n-2)

section .data
    ; Reserve 7 bytes for Fibonacci sequence
    ; Will contain: 1, 1, 2, 3, 5, 8, 13
    fib db 7 dup(0)

section .text
    global _start

_start:
    ; ========================================
    ; Step 1: Initialize first two Fibonacci numbers
    ; ========================================
    mov byte [fib], 1       ; fib[0] = 1 (this is Fib(1))
    mov byte [fib+1], 1     ; fib[1] = 1 (this is Fib(2))
    
    ; ========================================
    ; Step 2: Set up registers for loop
    ; ========================================
    ; AL will track Fib(n-2) - the second-to-last value
    ; BL will track Fib(n-1) - the most recent value
    mov al, 1               ; AL = prev2 = Fib(1) = 1
    mov bl, 1               ; BL = prev1 = Fib(2) = 1
    
    ; EDI points to the next array position we need to fill
    mov edi, fib            ; Start at beginning of array
    add edi, 2              ; Move to fib[2] (third position)
    
    ; We already have 2 values, need 5 more (positions 2-6)
    mov ecx, 5              ; Loop counter: iterate 5 times

fib_loop:
    ; ========================================
    ; Step 3: Calculate next Fibonacci number
    ; ========================================
    ; Formula: Fib(n) = Fib(n-1) + Fib(n-2)
    mov dl, bl              ; DL = prev1 (copy BL to DL)
    add dl, al              ; DL = prev1 + prev2 = next Fibonacci
    
    ; Store the newly calculated Fibonacci number
    mov [edi], dl           ; fib[index] = next Fibonacci value
    
    ; ========================================
    ; Step 4: Slide the window forward
    ; ========================================
    ; Update our tracking registers for the next iteration
    mov al, bl              ; prev2 now becomes old prev1
    mov bl, dl              ; prev1 now becomes the new value we just calculated
    
    ; Move array pointer to next position
    inc edi                 ; index++, point to next byte
    
    ; ========================================
    ; Step 5: Loop control
    ; ========================================
    ; LOOP instruction: decrements ECX and jumps if ECX != 0
    loop fib_loop           ; Continue until we've calculated all 5 remaining values
    
    ; ========================================
    ; Step 6: Exit program
    ; ========================================
done:
    mov ebx, 0              ; Return code 0 (success)
    mov eax, 1              ; System call number for exit
    int 0x80                ; Invoke system call

; Explanation:
; This program efficiently generates Fibonacci numbers using a sliding window approach.
; Instead of recalculating previous values, we keep track of the last two numbers
; in registers AL and BL, which is much faster than memory access.
; The loop runs exactly 5 times to generate Fib(3) through Fib(7).