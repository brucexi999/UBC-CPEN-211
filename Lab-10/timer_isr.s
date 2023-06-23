.include    "address_map_arm.s" 

.global TIMER_ISR
TIMER_ISR:
        LDR R2, =MPCORE_PRIV_TIMER
        MOV R3, #1
        STR R3, [R2, #0xc] // clear timer's interrput by writting 1 into the interrupt register

        LDR R0, =LED_BASE
        STR R1, [R0]
        MOV PC, LR
.end