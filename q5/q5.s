.option norelax

.section .rodata
filename:
.string "input.txt"
mode:
.string "r"
yes_str:
.string "Yes\n"
no_str:
.string "No\n"

.section .text
.extern fopen
.extern fseek
.extern ftell
.extern fread
.extern printf

.global main

main:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)

    la a0, filename
    la a1, mode
    jal ra, fopen
    addi s0, a0, 0

    addi a0, s0, 0
    addi a1, x0, 0
    addi a2, x0, 2
    jal ra, fseek

    addi a0, s0, 0
    jal ra, ftell
    addi s1, a0, 0

    addi s2, x0, 0
    addi s3, s1, -1

loop:
    bge s2, s3, is_palindrome

    addi a0, s0, 0
    addi a1, s2, 0
    addi a2, x0, 0
    jal ra, fseek

    addi t0, sp, 0
    addi a0, t0, 0
    addi a1, x0, 1
    addi a2, x0, 1
    addi a3, s0, 0
    jal ra, fread

    addi a0, s0, 0
    addi a1, s3, 0
    addi a2, x0, 0
    jal ra, fseek

    addi t1, sp, 1
    addi a0, t1, 0
    addi a1, x0, 1
    addi a2, x0, 1
    addi a3, s0, 0
    jal ra, fread

    lb t2, 0(sp)
    lb t3, 1(sp)
    bne t2, t3, not_palindrome

    addi s2, s2, 1
    addi s3, s3, -1
    jal x0, loop

is_palindrome:
    la a0, yes_str
    jal ra, printf
    jal x0, exit

not_palindrome:
    la a0, no_str
    jal ra, printf

exit:
    ld ra, 24(sp)
    ld s0, 16(sp)
    addi sp, sp, 32
    addi a0, x0, 0
    ret
