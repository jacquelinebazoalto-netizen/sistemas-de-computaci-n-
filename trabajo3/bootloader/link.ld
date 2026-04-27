SECTIONS
{
    . = 0x7c00;
    .text :
    {
        __start = .;
        *(.text)
        . = 0x1FE;
        SHORT(0xAA55)
    }

    /DISCARD/ :
    {
        *(.eh_frame)
        *(.debug_*)
        *(.note*)
        *(.comment)
    }
}