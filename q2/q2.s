.option norelax

.section .rodata
d_output:
.string "%d \0"

.text

.extern printf
.extern atoi

.global main
main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)   
    sd s1, 24(sp)    
    sd s2, 16(sp)
    sd s3, 8(sp)
    sd s4, 0(sp)

    # a0 = argc, a1 = argv

    addi s1, a0, -1     # n = argc - 1
    addi s2, a1, 8      # argv + 1
    addi s0, x0, 0

    # allocate 12*n bytes: arr + result + stack
    slli t0, s1, 1      # 2n
    add t0, t0, s1      # 3n
    slli t0, t0, 2      # 12n
    sub sp, sp, t0

    # arr base = sp
    # result base = sp + 4n

    slli t1, s1, 2
    add s5, sp, t1

    # stack base = sp + 8n
    slli t1, s1, 3
    add s3, sp, t1

    addi s4, x0, 0      # stack size = 0

    loop:
        bge s0, s1, loop_exit

        slli t0, s0, 3
        add t1, s2, t0
        ld a0, 0(t1)

        call atoi

        slli t0, s0, 2
        add t0, sp, t0
        sw a0, 0(t0)

        addi s0, s0, 1
        jal x0, loop

    loop_exit:

    addi t2, s1, -1     # i = n - 1

    stack_loop:
        blt t2, x0, stack_end

    while_loop:
        beq s4, x0, while_done

        addi t3, s4, -1
        slli t3, t3, 2
        add t3, s3, t3
        lw t4, 0(t3)        # index = stack.top()

        slli t5, t4, 2
        add t5, sp, t5
        lw t6, 0(t5)        # arr[top]

        slli t5, t2, 2
        add t5, sp, t5
        lw t0, 0(t5)        # arr[i]

        bgt t6, t0, while_done

        addi s4, s4, -1
        jal x0, while_loop

    while_done:

        beq s4, x0, no_ng

        addi t3, s4, -1
        slli t3, t3, 2
        add t3, s3, t3
        lw t4, 0(t3)

        slli t5, t2, 2
        add t5, s5, t5      # result base
        sw t4, 0(t5)

        jal x0, push_stack

    no_ng:
        slli t5, t2, 2
        add t5, s5, t5
        addi t6, x0, -1
        sw t6, 0(t5)

    push_stack:
        slli t3, s4, 2
        add t3, s3, t3
        sw t2, 0(t3)

        addi s4, s4, 1
        addi t2, t2, -1
        jal x0, stack_loop

    stack_end:

    addi s0, x0, 0

    output_loop:
        bge s0, s1, output_loop_exit

        slli t0, s0, 2
        add t0, s5, t0
        lw t1, 0(t0)

        la a0, d_output
        addi a1, t1, 0
        call printf

        addi s0, s0, 1
        jal x0, output_loop

    output_loop_exit:

    
    # free the 12n allocated bytes
    slli t0, s1, 1
    add t0, t0, s1
    slli t0, t0, 2
    add sp, sp, t0

    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    ld s4, 0(sp)
    addi sp, sp, 48
    ret
