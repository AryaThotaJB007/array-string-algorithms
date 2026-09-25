; Shifting Elements in an Array (Forward Rotation)
; Rotates array elements forward by one position
; Last element wraps around to the first position
; Example: [10, 20, 30, 40] → [40, 10, 20, 30]
;
; This program demonstrates rotation for 8-bit, 16-bit, and 32-bit arrays

section .data
    ; ===== 8-bit array (4 elements) =====
    arr8 db 10, 20, 30, 40
    LEN8 equ 4                      ; Number of elements
    
    ; ===== 16-bit array (4 elements) =====
    arr16 dw 100, 200, 300, 400
    LEN16 equ 4
    
    ; ===== 32-bit array (4 elements) =====
    arr32 dd 1000, 2000, 3000, 4000
    LEN32 equ 4

section .text
    global _start

_start:
    ; =========================================================
    ; PART 1: Rotate 8-bit array (bytes)
    ; [10, 20, 30, 40] → [40, 10, 20, 30]
    ; =========================================================
    mov esi, arr8                   ; ESI = base address of arr8
    
    ; Step 1: Save the last element
    mov al, [esi + LEN8 - 1]        ; AL = arr8[3] = 40
    
    ; Step 2: Shift elements right using a countdown loop
    ; We need to shift positions 3, 2, 1 (indices from high to low)
    mov ecx, LEN8 - 1               ; ECX = 3 (number of shifts needed)
    
rotate8_loop:
    ; For arr8[i] = arr8[i-1], where i starts at 3 and counts down
    mov bl, [esi + ecx - 1]         ; BL = arr8[i-1] (element to the left)
    mov [esi + ecx], bl             ; arr8[i] = BL
    dec ecx                         ; Move to previous position
    jnz rotate8_loop                ; Continue if ECX != 0
    
    ; Step 3: Place saved element at front
    mov [esi], al                   ; arr8[0] = 40
    ; Result: arr8 = [40, 10, 20, 30]
    
    ; =========================================================
    ; PART 2: Rotate 16-bit array (words)
    ; [100, 200, 300, 400] → [400, 100, 200, 300]
    ; =========================================================
    mov esi, arr16                  ; ESI = base of arr16
    
    ; Step 1: Save last element (at byte offset 6 = 3 * 2)
    mov ax, [esi + (LEN16 - 1) * 2] ; AX = arr16[3] = 400
    
    ; Step 2: Shift elements using byte offsets
    ; EDI will track the current byte offset
    mov edi, (LEN16 - 1) * 2        ; EDI = 6 (offset of last element)
    mov ecx, LEN16 - 1              ; ECX = 3 (number of shifts)
    
rotate16_loop:
    mov bx, [esi + edi - 2]         ; BX = arr16[i-1]
    mov [esi + edi], bx             ; arr16[i] = BX
    sub edi, 2                      ; Move offset back by 2 bytes
    dec ecx
    jnz rotate16_loop
    
    ; Step 3: Place saved element at front
    mov [esi], ax                   ; arr16[0] = 400
    ; Result: arr16 = [400, 100, 200, 300]
    
    ; =========================================================
    ; PART 3: Rotate 32-bit array (dwords)
    ; [1000, 2000, 3000, 4000] → [4000, 1000, 2000, 3000]
    ; =========================================================
    mov esi, arr32                  ; ESI = base of arr32
    
    ; Step 1: Save last element (at byte offset 12 = 3 * 4)
    mov eax, [esi + (LEN32 - 1) * 4] ; EAX = arr32[3] = 4000
    
    ; Step 2: Shift elements using byte offsets
    mov edi, (LEN32 - 1) * 4        ; EDI = 12 (offset of last element)
    mov ecx, LEN32 - 1              ; ECX = 3 (number of shifts)
    
rotate32_loop:
    mov ebx, [esi + edi - 4]        ; EBX = arr32[i-1]
    mov [esi + edi], ebx            ; arr32[i] = EBX
    sub edi, 4                      ; Move offset back by 4 bytes
    dec ecx
    jnz rotate32_loop
    
    ; Step 3: Place saved element at front
    mov [esi], eax                  ; arr32[0] = 4000
    ; Result: arr32 = [4000, 1000, 2000, 3000]

done:
    ; =========================================================
    ; EXIT
    ; =========================================================
    mov ebx, 0                      ; Return code 0
    mov eax, 1                      ; sys_exit
    int 0x80

; =====================================================
; ALGORITHM EXPLANATION:
; =====================================================
; Forward rotation works by:
; 1. Saving the last element in a temporary register
; 2. Shifting all elements one position to the right
; 3. Placing the saved element at the beginning
;
; The key insight is that we must shift from right to left
; (high index to low) to avoid overwriting data we haven't
; copied yet.
;
; Wrong approach (would lose data):
;    arr[0] = arr[1]  // Overwrites arr[0] before we save it!
;    arr[1] = arr[2]
;    ...
;
; Correct approach (our algorithm):
;    temp = arr[3]
;    arr[3] = arr[2]  // Working backward preserves data
;    arr[2] = arr[1]
;    arr[1] = arr[0]
;    arr[0] = temp
;
; For different element sizes:
; - 8-bit:  Use simple indexing (element size = 1 byte)
; - 16-bit: Multiply index by 2 for byte offset
; - 32-bit: Multiply index by 4 for byte offset