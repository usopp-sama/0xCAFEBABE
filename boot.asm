ORG 0                ; Set origin to 0 (this should typically be 0x7C00 for bootloaders)
BITS 16              ; Specify 16-bit mode, as the CPU starts in Real Mode

jmp 0x7c0:start      ; makes code segmment to 0x7c0

start:

    cli              ; Clear interrupts to prevent unexpected behavior during setup
    mov ax, 0x7c0    ; Load segment base address (0x7C00 / 16 = 0x7C0) into AX
    mov ds, ax       ; Set Data Segment (DS) to 0x7C0 (where the bootloader is loaded)
    mov es, ax       ; Set Extra Segment (ES) to the same base address

    mov ax, 0x00     ; Set up the Stack Segment (SS) to 0x0000 (standard for bootloaders)
    mov ss, ax       ; Load Stack Segment
    mov sp, 0x7c00   ; Set Stack Pointer (SP) to 0x7C00 (prevents overwriting our code)
    sti              ; Enable interrupts after setup is complete

    mov si, message  ; Load the address of 'message' into SI (source index for string operations)
    call print       ; Call the print function to display the message
    jmp $            ; Infinite loop to halt execution (prevents running into uninitialized memory)

; Function to print a null-terminated string
print:
    mov bx, 0        ; Clear BX (not actually needed here, but good practice)
.loop:
    lodsb            ; Load next character from [SI] into AL, and increment SI
    cmp al, 0        ; Check if it's the null terminator
    je .done         ; If yes, jump to the end of the function
    call print_char  ; Otherwise, print the character
    jmp .loop        ; Repeat the loop for the next character
.done:
    ret              ; Return from the function

; Function to print a single character to the screen
print_char:
    mov ah, 0Eh      ; BIOS teletype function (int 0x10, AH=0x0E) for character output
    int 0x10         ; Call BIOS interrupt to print the character in AL
    ret              ; Return from function

message: db 'My Nigga. I love you ^._.^', 0  ; Define the message string with a null terminator

; Fill the remaining space with zeros until we reach 510 bytes
times 510- ($ - $$) db 0 

dw 0xAA55           ; Boot sector signature (BIOS requires this at the end of a valid bootloader)
