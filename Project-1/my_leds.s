    AREA asm_func, CODE, READONLY
    EXPORT my_leds

my_leds
    PUSH    {R1, R2, LR}
    MOV     R1, R0              ; R1 is copy of input
    AND     R1, #1              ; R1 && 1
    LSL     R2, R1, #18         ; R2 = R1 << 18 (for LED pin 18)
    MOV     R1, R0              ; R1 is copy of input
    AND     R1, #6              ; R1 && 110
    LSL     R1, #19             ; R1 = R1 << 19 (for LED pins 20 and 21)
    ORR     R2, R1              ; R2 = R2 || R1
    MOV     R1, R0              ; R1 is copy of input
    AND     R1, #8              ; R1 && 1000
    LSL     R1, #20             ; R1 = R1 << 20 (for LED pin 23)
    ORR     R2, R1              ; R2 = R2 || R1
    LDR     R1, =0x2009C020     ; R1 = FIODIR base
    STR     R2, [R1, #0x18]     ; write R2 to FIOSET
    BL      wait                ; call to wait
    POP     {R1, R2, LR}        ; restore registers
    BX      LR                  ; return from my_leds
    ALIGN                       ; end of me_leds function
    
wait                            ; start of wait subroutine
    PUSH    {R1, R2}            ; get 2 registers to use
    MOV.W   R1, #1              ; R1 is 1
    LDR     R2, =0x989680       ; R2 is limit which is 10000000
loop_entry
    CMP     R1, R2              ; R1 - R2
    BGT     loop_exit           ; if R1 > R2 exit
    ADD     R1, R1, #1          ; R1++
    B       loop_entry          ; Return
loop_exit
    POP     {R1, R2}            ; restore registers
    BX      LR                  ; return from wait
    ALIGN
    END

