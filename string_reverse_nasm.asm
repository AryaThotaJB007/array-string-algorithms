; Copy a String in Reverse Order
; Copies a null-terminated string from source to target, reversing character order
; Example: "This is the source string" → "gnirts ecruos eht si sihT"

section .data
    ; Original string to be reversed
    source db "This is the source string", 0
    
    ; ===== String constants (like MASM's SIZEOF/TYPE/LENGTHOF) =====
    TYPE_source equ 1                          ; BYTE size
    SIZEOF_source equ ($ - source)             ; Total bytes including null
    LENGTHOF_source equ SIZEOF_source - 1      ; Characters excluding null
    
    ; Target buffer: same size as source, initially filled with '#'
    ; This makes it easy to see if we missed any characters
    target db SIZEOF_source dup('#')

section .text
    global _start

_start:
    ; =====================================================
    ; SETUP: Position pointers for reverse copy
    ; =====================================================
    ; ESI will read from source, starting at the LAST character
    mov esi, source                 ; Start at beginning
    add esi, LENGTHOF_source - 1    ; Move to last real character
    ; ESI now points to 'g' (last char of "string")
    
    ; EDI will write to target, starting at the FIRST position
    mov edi, target                 ; EDI = address of target[0]
    
    ; ECX counts how many characters we need to copy
    mov ecx, LENGTHOF_source        ; Number of characters (not counting null)

reverse_copy_loop:
    ; =====================================================
    ; CHECK: If counter is zero, we're done
    ; =====================================================
    cmp ecx, 0                      ; Check if ECX == 0
    je done_copy                    ; If zero, jump to finish
    
    ; =====================================================
    ; COPY: Move one character from source to target
    ; =====================================================
    mov al, [esi]                   ; AL = current source character
    mov [edi], al                   ; target[current] = AL
    
    ; =====================================================
    ; MOVE POINTERS: ESI backward, EDI forward
    ; =====================================================
    dec esi                         ; Move backward in source (toward beginning)
    inc edi                         ; Move forward in target (toward end)
    
    ; =====================================================
    ; DECREMENT: Count down and loop
    ; =====================================================
    dec ecx                         ; Decrease character count
    jmp reverse_copy_loop           ; Continue loop
    
done_copy:
    ; =====================================================
    ; NULL TERMINATOR: Properly end the string
    ; =====================================================
    ; At this point, EDI points to target[LENGTHOF_source]
    ; We need to write a null terminator there
    mov byte [target + LENGTHOF_source], 0
    
    ; Now we have:
    ; source = "This is the source string\0"
    ; target = "gnirts ecruos eht si sihT\0"

done:
    ; =====================================================
    ; EXIT: Terminate program
    ; =====================================================
    mov ebx, 0                      ; Return code 0
    mov eax, 1                      ; sys_exit
    int 0x80

; =====================================================
; ALGORITHM EXPLANATION:
; =====================================================
; This program demonstrates pointer arithmetic for string manipulation:
;
; 1. Calculate the string length at assembly time using SIZEOF and subtracting 1
;    for the null terminator
;
; 2. Set up two pointers moving in opposite directions:
;    - ESI starts at the end of source and moves backward
;    - EDI starts at the beginning of target and moves forward
;
; 3. Each iteration:
;    - Copy one byte from source to target
;    - Move ESI one position left (dec)
;    - Move EDI one position right (inc)
;
; 4. After copying all characters, add null terminator to target
;