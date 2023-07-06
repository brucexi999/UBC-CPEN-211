// Copied from "part3.s"
.include    "address_map_arm.s" 
.include    "interrupt_ID.s" 

/* ********************************************************************************
 * This program demonstrates use of interrupts with assembly language code.
 * The program responds to interrupts from the pushbutton KEY port in the FPGA.
 *
 * The interrupt service routine for the pushbutton KEYs indicates which KEY has
 * been pressed on the LED display.
 ********************************************************************************/

.section    .vectors, "ax" 

            B       _start                  // reset vector
            B       SERVICE_UND             // undefined instruction vector
            B       SERVICE_SVC             // software interrrupt vector
            B       SERVICE_ABT_INST        // aborted prefetch vector
            B       SERVICE_ABT_DATA        // aborted data vector
.word       0 // unused vector
            B       SERVICE_IRQ             // IRQ interrupt vector
            B       SERVICE_FIQ             // FIQ interrupt vector

.text        
.global     _start 
_start:                                     
/* Set up stack pointers for IRQ and SVC processor modes */
            MOV     R1, #0b11010010         // interrupts masked, MODE = IRQ
            MSR     CPSR_c, R1              // change to IRQ mode
            LDR     SP, =A9_ONCHIP_END - 3  // set IRQ stack to top of A9 onchip memory
/* Change to SVC (supervisor) mode with interrupts disabled */
            MOV     R1, #0b11010011         // interrupts masked, MODE = SVC
            MSR     CPSR, R1                // change to supervisor mode
            LDR     SP, =DDR_END - 3        // set SVC stack to top of DDR3 memory

            BL      CONFIG_GIC              // configure the ARM generic interrupt controller

                                            // write to the pushbutton KEY interrupt mask register
            LDR     R0, =KEY_BASE           // pushbutton KEY base address
            MOV     R1, #0xF               // set interrupt mask bits
            STR     R1, [R0, #0x8]          // interrupt mask register is (base + 8)

                                            // enable IRQ interrupts in the processor
            MOV     R0, #0b01010011         // IRQ unmasked, MODE = SVC
            MSR     CPSR_c, R0
            
            # configure timer
            LDR     R0, =MPCORE_PRIV_TIMER  // address load register of the timer, also the base address of timer
            LDR     R1, =timer_load_value          // decimal value of 100 M
            LDR     R2, [R1]
            STR     R2, [R0]                // write the load register

            MOV     R1, #7                  // set the enable, auto-reload and interrupt bit in the control register to 1, prescalar = 0
            STR     R1, [R0, #0x8]          // controll register is (base + 8)
            # ---------------

            # configure JTAG UART
            LDR     R0, =JTAG_UART_BASE     // base address of the JTAG UART, also the data register
            MOV     R1, #1
            STR     R1, [R0, #0x4]          // write 1 to the controll register, set RE bit to 1, to enable interrupt from JTAG UART receiver FIFO

IDLE:                                       
            LDR     R0, =CHAR_FLAG          // read CHAR_FLAG
            LDR     R1, [R0]
            CMP     R1, #1                  // if it is 0, then stay in this polling process

            BNE     IDLE                    // main program simply idles

            LDR     R1, =CHAR_BUFFER        // if CHAR_FLAG is 1, then read the car in CHAR_BUFFER in r0
            LDR     R0, [R1]

            LDR     R2, =CHAR_FLAG          // set CHAR_FLAG to 0
            MOV     R3, #0
            STR     R3, [R2]

            BL      PUT_JTAG
            B       IDLE

PROC1:
            LDR     R4, =count              // read count
            LDR     R0, [R4]
            ADD     R0, R0, #1              // count++
            STR     R0, [R4]                // write count
            LDR     R1, =LED_BASE
            STR     R0, [R1]                // *ledr = count
            MOV     R2, #0                  // i = 0
            LDR     R3, =large_number                // LARGE_NUMEBR = 0x00ffffff
            LDR     R3, [R3]
LOOP:
            CMP     R2, R3
            BLT     SMALLER                 
            B       PROC1
SMALLER:
            ADD     R2, R2, #1              // i++
            B       LOOP

            

/* Define the exception service routines */

/*--- Undefined instructions --------------------------------------------------*/
SERVICE_UND:                                
            B       SERVICE_UND             

/*--- Software interrupts -----------------------------------------------------*/
SERVICE_SVC:                                
            B       SERVICE_SVC             

/*--- Aborted data reads ------------------------------------------------------*/
SERVICE_ABT_DATA:                           
            B       SERVICE_ABT_DATA        

/*--- Aborted instruction fetch -----------------------------------------------*/
SERVICE_ABT_INST:                           
            B       SERVICE_ABT_INST        

/*--- IRQ ---------------------------------------------------------------------*/
SERVICE_IRQ:                                
            PUSH    {R0-R7, LR}             

/* Read the ICCIAR from the CPU interface */
            LDR     R4, =MPCORE_GIC_CPUIF   
            LDR     R5, [R4, #ICCIAR]       // read from ICCIAR

FPGA_IRQ1_HANDLER:                          
            CMP     R5, #KEYS_IRQ
            BEQ     KEY
FPGA_IRQ2_HANDLER:
            CMP     R5, #29
            BEQ     TIMER
FPGA_IRQ3_HANDLER:     
            CMP     R5, #80
            BEQ     JTAG_UART
UNEXPECTED: 
            BNE     UNEXPECTED              // if not recognized, stop here
KEY:
            BL      KEY_ISR
            B       EXIT_IRQ
TIMER:
            LDR R0, =MPCORE_PRIV_TIMER
            MOV R1, #1
            STR R1, [R0, #0xc] // clear timer's interrput by writting 1 into the interrupt register

            // check process ID
            LDR     R0, =CURRENT_PID
            LDR     R0, [R0]
            CMP     R0, #0
            BEQ     P0_SAVE
P1_SAVE:
            LDR     R0, =PD_ARRAY
            ADD     R0, R0, #0x44
            B       SAVE

            // ------save to PD------------
P0_SAVE:
            LDR     R0, =PD_ARRAY           
SAVE:
            //STR     R1, [R0, #4]
            STR     R2, [R0, #8]
            STR     R3, [R0, #12]
            STR     R6, [R0, #24]
            STR     R7, [R0, #28]
            STR     R8, [R0, #32]
            STR     R9, [R0, #36]
            STR     R10, [R0, #40]
            STR     R11, [R0, #44]
            STR     R12, [R0, #48]

            STR     LR, [R0, #60]           // save PC using the value of LR

            MRS     R1, SPSR                
            STR     R1, [R0, #64]           // save CPSR

            MOV     R1, #0b11010011            // supervisor mode, IRQ disabled
            MSR     CPSR, R1

            STR     SP, [R0, #52]
            STR     LR, [R0, #56]

            MOV     R1, #0b11010010         // interrupts masked, MODE = IRQ
            MSR     CPSR, R1              // change to IRQ mode

            LDR     R1, [SP, #4]
            LDR     R4, [SP, #16]           // restore from the ISR stack the value of R0, R4, R5 for the interrupted process
            LDR     R5, [SP, #20]
            STR     R1, [R0, #4]
            STR     R4, [R0, #16]
            STR     R5, [R0, #20]
            LDR     R1, [SP]           
            STR     R1, [R0]

            POP     {R0-R7, LR}             // adjust the stack, no impact on functionality
            
            // ------flip the PID upon timer interruption------
            LDR     R0, =CURRENT_PID
            LDR     R1, [R0]
            MVN     R1, R1
            AND     R1, R1, #1
            STR     R1, [R0]

            // check process ID
            LDR     R0, =CURRENT_PID
            LDR     R0, [R0]
            CMP     R0, #0
            BEQ     P0_RESTORE
P1_RESTORE:
            LDR     R0, =PD_ARRAY
            ADD     R0, R0, #0x44
            B       RESTORE
P0_RESTORE:
            // -------restore from PD---------
            LDR     R0, =PD_ARRAY
RESTORE:
            LDR     R2, [R0, #8]
            LDR     R3, [R0, #12]
            LDR     R6, [R0, #24]
            LDR     R7, [R0, #28]
            LDR     R8, [R0, #32]
            LDR     R9, [R0, #36]
            LDR     R10, [R0, #40]
            LDR     R11, [R0, #44]
            LDR     R12, [R0, #48]

            //MOV     R1, #0b11010011            // supervisor mode, IRQ disabled
            //MSR     CPSR, R1

            LDR     SP, [R0, #52]
            LDR     LR, [R0, #60]

            //MOV     R1, #0b11010010         // interrupts masked, MODE = IRQ
            //MSR     CPSR, R1              // change to IRQ mode

            //MOV     R1, #0b01010011             // supervisor mode, IRQ disabled
            //MSR     CPSR, R1

            //LDR     SP, [R0, #52]               // restore SP and LR
            //LDR     LR, [R0, #60]               // put value of PC in the PD array into LR

            //MOV     R1, #0b11010010         // interrupts masked, MODE = IRQ
            //MSR     CPSR_c, R1              // change to IRQ mode

            LDR     R1, [R0, #64]
            MSR     SPSR, R1                    // restore SPSR

            LDR     R4, =MPCORE_GIC_CPUIF   
            LDR     R5, [R4, #ICCIAR]
            STR     R5, [R4, #ICCEOIR]      // write to ICCEOIR

            LDR     R4, [R0, #16]
            LDR     R5, [R0, #20]            
            LDR     R1, [R0, #4]                // retore R1, R0, R4, R5 when it is certain that they won't get overwritten
            LDR     R0, [R0]
            
            SUBS    PC, LR, #4
            
JTAG_UART:
            LDR     R0, =JTAG_UART_BASE
            LDR     R1, [R0]                // read the receive FIFO into r1, this also clears the interrupt signal
            AND     R1, R1, #0xFF           // extract only the lower 8 bits

            LDR     R2, =CHAR_FLAG          // set CHAR_FLAG to 1
            MOV     R3, #1
            STR     R3, [R2]

            LDR     R2, =CHAR_BUFFER        // write the char to CHAR_BUFFER
            STR     R1, [R2]
            B       EXIT_IRQ                


EXIT_IRQ:                                   
/* Write to the End of Interrupt Register (ICCEOIR) */
            STR     R5, [R4, #ICCEOIR]      // write to ICCEOIR

            POP     {R0-R7, LR}             
            SUBS    PC, LR, #4              

/*--- FIQ ---------------------------------------------------------------------*/
SERVICE_FIQ:                                
            B       SERVICE_FIQ     

// the global variable used for timer TSR
timer_variable:
.word 0

// the value tha being loaded into the timer
timer_load_value:
.word 0x1FAF208 

CHAR_FLAG:
.word 0

CHAR_BUFFER:
.word 0

count:
.word 0

CURRENT_PID: 
.word 0

PD_ARRAY: 
.fill 17,4,0xDEADBEEF
.fill 13,4,0xDEADBEE1
.word 0x3F000000 // SP
.word 0 // LR
.word PROC1+4 // PC
.word 0x53 // CPSR (0x53 means IRQ enabled, mode = SVC)

large_number:
.word 0x00ffffff

.end         
