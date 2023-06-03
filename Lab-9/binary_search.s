.globl binary_search
binary_search:

// r4 = middleIndex
// r5 = NumCalls
// r6 = numbers[middleIndex]
// r7 = keyIndex
    sub sp, sp, #24
    str r7, [sp, #20]
    str r6, [sp, #16]
    str r5, [sp, #12]
    str r4, [sp, #8] // backup registers
    str lr, [sp, #4] // backup lr and r0 because we are doing recursive calls
    str r0, [sp, #0]
    ldr r5, [sp, #24] // get Numcalls from stack
    sub r4, r3, r2 // endIndex - startIndex
    add r4, r2, r4, LSR #1 // middleIndex = startIndex + (endIndex - startIndex)/2;
    add r5, r5, #1 // NumCalls++
    ldr r6, [r0, r4, LSL #2] // numbers[middleIndex]
    cmp r2, r3 
    bgt error // if (startIndex > endIndex) {return -1;}
    cmp r6, r1
    beq equal // else if (numbers[middleIndex] == key) {keyIndex = middleIndex;}
    bgt greater // else if (numbers[middleIndex] > key) {keyIndex = binary_search(numbers, key, startIndex, middleIndex-1, NumCalls);}
    b smaller // else {keyIndex = binary_search(numbers, key, middleIndex+1, endIndex, NumCalls);}

greater:
    sub sp, sp, #4
    str r5,[sp, #0]     // save 5th arg to stack
    sub r3, r4, #1 // middleIndex-1 -> 4th argument
    bl binary_search
    mov r7, r0 // keyIndex = return
    ldr r0, [sp, #0]
    ldr lr, [sp, #4] // restore the value of r0 and lr
    b done

smaller:
    sub sp, sp, #4
    str r5,[sp, #0]     // save 5th arg to stack
    add r2, r4, #1 // middleIndex+1 -> 3rd argument 
    bl binary_search
    mov r7, r0 // keyIndex = return
    ldr r0, [sp, #0]
    ldr lr, [sp, #4] // restore the value of r0 and lr
    b done

error:
    mov r0, #-1 // return -1
    ldr r7, [sp, #20]
    ldr r6, [sp, #16]
    ldr r5, [sp, #12]
    ldr r4, [sp, #8] // restore r4-r7
    add sp, sp, #28 // 24 + 4, where 4 is the 5th argument from the caller, the callee get rid of this as well
    mov pc, lr // get back to main

equal:
    mov r7, r4 // keyIndex = middleIndex;
    b done

done:
    rsb r5, r5, #0 // r5 = -NumCalls
    str r5, [r0, r4, LSL #2] // numbers[middleIndex] = -NumCalls
    mov r0, r7 // return keyIndex;
    ldr r7, [sp, #20]
    ldr r6, [sp, #16]
    ldr r5, [sp, #12]
    ldr r4, [sp, #8] // restore r4-r7
    add sp, sp, #28 // 24 + 4, where 4 is the 5th argument from the caller, the callee get rid of this as well
    mov pc, lr // get back to caller

