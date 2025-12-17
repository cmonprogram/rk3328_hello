.section .text
.global _start

.equ UART_BASE, 0xff130000
.equ UART_THR,  0x00
.equ UART_LSR,  0x14
.equ LSR_THRE,  (1 << 5) 

_start:
    adr     x0, msg 

print_loop:
    ldrb    w1, [x0], #1 
    cbz     w1, done

wait_uart:
    ldr     x2, =UART_BASE
    ldr     w3, [x2, #UART_LSR]
    tst     w3, #LSR_THRE
    beq     wait_uart

    str     w1, [x2, #UART_THR]
    b       print_loop

done:
    ret 

.section .data
msg:
    .asciz "Hello from RK3328!\r\n"
