#include <machine/asm.h>
#include <sys/linux-syscalls.h>

#ifndef __NR_vfork
#define __NR_vfork  190
#endif


/* Get rid of the stack modifications (popl/ret) after vfork() success.
 * vfork is VERY sneaky. One has to be very careful about what can be done
 * between a successful vfork and a a subsequent execve()
 */

ENTRY(vfork)
    /* grab the return address */
    popl    %ecx
    movl    $__NR_vfork, %eax
    int     $0x80
    cmpl    $-129, %eax
    jb      1f
    negl    %eax
    pushl   %eax
    call    PIC_PLT(__set_errno)
    orl     $-1, %eax
1:
    jmp     *%ecx
END(vfork)
