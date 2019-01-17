    AREA asm_func, CODE, READONLY
    EXPORT asm_sort

asm_sort
    PUSH    {R2, R3, R4, R5, R6, R7, R8, LR}
    MOV.W   R2, #0                                      ; R2 = out_count = 0
    MOV.W   R3, R1                                      ; R3 = size
    SUB     R3, R3, #2                                  ; R3 = size - 2
outer_loop_entry
    BL      my_leds
    CMP     R2, R3                                      ; R2 - R3
    BGT     outer_loop_exit                             ; if R2 > R3 exit
    MOV.W   R4, #0                                      ; R4 = in_count = 0
    MOV.W   R5, R3                                      ; R5 = size - 2
    SUB     R5, R5, R2                                  ; R5 = size - 2 - out_count
inner_loop_entry
    CMP     R4, R5                                      ; R4 - R5
    BGT     inner_loop_exit                             ; if R4 > R5 exit
compare_and_swap_entry
    MOV     R6, R4                                      ; R6 = in_count
    ADD     R6, R6, #1                                  ; R6 = in_count + 1
    LDR     R7, [R0, R4, LSL #2]                        ; R7 = numbers[R4] = numbers[in_count]
    LDR     R8, [R0, R6, LSL #2]                        ; R8 = numbers[R6] = numbers[in_count + 1]
    CMP     R7, R8                                      ; R7 - R8
    BLE     compare_and_swap_exit                       ; if R7 <= R8 exit
    STR     R7, [R0, R6, LSL #2]                        ; numbers[R4] = R8
    STR     R8, [R0, R4, LSL #2]                        ; numbers[R6] = R7
compare_and_swap_exit  
    ADD     R4, R4, #1                                  ; R4++
    B       inner_loop_entry                            ; return to start of inner loop
inner_loop_exit
    ADD     R2, R2, #1                                  ; R2++
    B       outer_loop_entry                            ; return to start of outer loop
outer_loop_exit   
    POP     {R2, R3, R4, R5, R6, R7, R8, LR}            ; restore registers
    BX      LR                                          ; return from wait
    ALIGN                                               ; end of asm_sort function
    
my_leds                                                 ; start of my_leds subroutine
    PUSH    {R0, R1, LR}
    MOV     R0, R2                                      ; R0 is copy of R2 = out_count
    AND     R0, #1                                      ; R0 && 1
    LSL     R1, R0, #18                                 ; R1 = R0 << 18 (for LED pin 18)
    MOV     R0, R2                                      ; R0 is R2
    AND     R0, #6                                      ; R0 && 110
    LSL     R0, #19                                     ; R0 = R0 << 19 (for LED pins 20 and 21)
    ORR     R1, R0                                      ; R1 = R1 || R0
    MOV     R0, R2                                      ; R0 is copy of R2
    AND     R0, #8                                      ; R0 && 1000
    LSL     R0, #20                                     ; R0 = R0 << 20 (for LED pin 23)
    ORR     R1, R0                                      ; R1 = R1 || R0
    LDR     R0, =0x2009C020                             ; R0 = FIODIR base
    STR     R1, [R0, #0x18]                             ; write R1 to FIOSET
    BL      wait                                        ; call to wait
    STR     R1, [R0, #0x1C]                             ; write R1 to FIOCLR
    POP     {R0, R1, LR}
    BX      LR
    ALIGN                                               ; end of me_leds subroutine
    
wait                                                    ; start of wait subroutine
    PUSH    {R0, R1}                                    ; get 2 registers to use
    MOV.W   R0, #1                                      ; R0 is 1
    LDR     R1, =0x989680                               ; R1 is limit which is 10000000
loop_entry
    CMP     R0, R1                                      ; R0 - R1
    BGT     loop_exit                                   ; if R0 > R1 exit
    ADD     R0, R0, #1                                  ; R0++
    B       loop_entry                                  ; Return
loop_exit
    POP     {R0, R1}                                    ; restore registers
    BX      LR                                          ; return from wait
    ALIGN                                               ; end of wait subroutine
    END
