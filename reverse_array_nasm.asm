; Reverse an Array Program
; Reverses a DWORD integer array in place using two-pointer technique
; Uses SIZEOF, TYPE, and LENGTHOF operators for flexibility

section .data
    ; Array of 32-bit integers (DWORDs) to reverse
    ; Initial: [1, 2, 3, 4, 5, 6, 7]
    ; Final:   [7, 6, 5, 4, 3, 2, 1]
    intArray dd 1, 2, 3, 4, 5, 6, 7
    
    ; ===== Flexible Constants (like MASM's SIZEOF/TYPE/LENGTHOF) =====
    ; These allow easy modification if array size or type changes
    TYPE_intArray equ 4                    ; Size of each element (DWORD = 4 bytes)
    SIZEOF_intArray equ ($ - intArray)     ; Total array size in bytes
    LENGTHOF_intArray equ SIZEOF_intArray / TYPE_intArray  ; Number of elements
    SWAP_COUNT equ LENGTHOF_intArray / 2   ; How many pairs to swap

section .text
    global _start

_start:
    ; =====================================================
    ; SETUP: Initialize pointers to array ends
    ; =====================================================
    ; ESI will point to the LEFT end (first element)
    mov esi, intArray           ; ESI = address of intArray[0]
    
    ; EDI will point to the RIGHT end (last element)
    mov edi, intArray           ; Start at beginning
    add edi, SIZEOF_intArray    ; Move to one byte past end
    sub edi, TYPE_intArray      ; Back up to last element
    ; Now EDI points to intArray[6]
    
    ; ECX will count how many swaps we need to perform
    mov ecx, SWAP_COUNT         ; ECX = 3 (for 7 elements, swap 3 pairs)

reverse_loop:
    ; =====================================================
    ; SWAP: Exchange elements at ESI and EDI
    ; =====================================================
    ; Step 1: Load left element into temporary register
    mov eax, [esi]              ; EAX = intArray[left]
    
    ; Step 2: Load right element into another register
    mov ebx, [edi]              ; EBX = intArray[right]
    
    ; Step 3: Write right element to left position
    mov [esi], ebx              ; intArray[left] = right value
    
    ; Step 4: Write saved left element to right position
    mov [edi], eax              ; intArray[right] = old left value
    
    ; =====================================================
    ; MOVE POINTERS: Step inward toward center
    ; =====================================================
    add esi, TYPE_intArray      ; Move left pointer right (+4 bytes)
    sub edi, TYPE_intArray      ; Move right pointer left (-4 bytes)
    
    ; =====================================================
    ; LOOP CONTROL: Decrement counter and repeat if not zero
    ; =====================================================
    loop reverse_loop           ; ECX--, jump if ECX != 0
    ; LOOP instruction automatically:
    ; 1. Decrements ECX
    ; 2. Jumps to reverse_loop if ECX is not zero
    
done:
    ; =====================================================
    ; EXIT: Terminate program
    ; =====================================================
    mov ebx, 0                  ; Return code 0 (success)
    mov eax, 1                  ; System call 1 = sys_exit
    int 0x80                    ; Invoke kernel

; =====================================================
; ALGORITHM EXPLANATION:
; =====================================================
; This program uses the "two-pointer" technique to reverse an array:
; 
; 1. Start with one pointer at the beginning (ESI) and one at the end (EDI)
; 2. Swap the elements they point to
; 3. Move both pointers toward the center
; 4. Repeat until pointers meet in the middle
;
; For an array of 7 elements, we need 3 swaps:
;    Iteration 1: Swap positions 0 ↔ 6  →  [7,2,3,4,5,6,1]
;    Iteration 2: Swap positions 1 ↔ 5  →  [7,6,3,4,5,2,1]
;    Iteration 3: Swap positions 2 ↔ 4  →  [7,6,5,4,3,2,1]
;    Middle element (index 3) stays in place
;
; Using TYPE_intArray throughout means if we change from DWORD to WORD
; or BYTE, the code automatically adapts - we just change the array
; declaration and TYPE_intArray value.