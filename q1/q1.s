.option norelax

.extern malloc

.global make_node
make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    
    addi s0, a0, 0
    addi a0, x0, 24

    call malloc

    sw s0, 0(a0)
    sd x0, 8(a0)
    sd x0, 16(a0)

    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret


.global insert
insert:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    bne a0, x0, not_null

    addi a0, a1, 0
    call make_node
    jal x0, insert_done

    not_null:
        addi s0, a0, 0
        lw t0, 0(s0)
        blt t0, a1, insert_right

        insert_left:
            ld a0, 8(s0)
            call insert
            sd a0, 8(s0)
            addi a0, s0, 0
            jal x0, insert_done
        
        insert_right:
            ld a0, 16(s0)
            call insert
            sd a0, 16(s0)
            addi a0, s0, 0
    
    insert_done:
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret


.global get
get:
    addi sp, sp, -16
    sd ra, 8(sp)

    beq a0, x0, get_done

    lw t0, 0(a0)

    beq t0, a1, get_done
    blt t0, a1, get_right

    get_left:
        ld a0, 8(a0)
        call get
        jal x0, get_done
    get_right:
        ld a0, 16(a0)
        call get

    get_done:

    ld ra, 8(sp)
    addi sp, sp, 16
    ret


.global getAtMost
getAtMost:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    beq a1, x0, not_found

    lw t0, 0(a1)

    bgt t0, a0, go_left

    addi s0, t0, 0

    ld a1, 16(a1)
    call getAtMost

    addi t1, x0, -1
    beq a0, t1, use 

    jal x0, atmost_done 

    use:
        addi a0, s0, 0
        jal x0, atmost_done

    go_left:
        ld a1, 8(a1)
        call getAtMost
        jal x0, atmost_done

    not_found:
        addi a0, x0, -1

    atmost_done:
    
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret
