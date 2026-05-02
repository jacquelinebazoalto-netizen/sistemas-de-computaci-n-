.code16

/*
 * Definición de los selectores de segmento.
 * Un selector es el índice del descriptor en la
 * GDT multiplicado por 8 (tamaño de cada entrada).
 * Descriptor 0 → offset 0x00 (nulo)
 * Descriptor 1 → offset 0x08 (código)
 * Descriptor 2 → offset 0x10 (datos)
 */
.equ CODE_SEG, 8
.equ DATA_SEG, gdt_data - gdt_start

/* 
 * Inicialización en modo real.
 * Antes de tocar la GDT hay que asegurarse de que los registros de segmento y la pila estén
 * en un estado conocido y controlado. 
 */
    /* Deshabilitar interrupciones. Durante la transición
     * a modo protegido la IVT (interrupt vector table) de modo real deja de ser
     * válida. CLI previene que una interrupción de hardware
     * dispare código inválido en ese momento.
     */
    CLI

    /* Inicializar registros de segmento a 0.
     * No se puede cargar un segmento con un inmediato
     * directamente, hay que pasar por un registro general.
     */
    mov $0, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss

    /* Pila justo debajo de nuestro código.
     * El código está en 0x7c00, la pila crece hacia
     * abajo desde ahí y no lo pisa.
     */
    mov $0x7c00, %sp

/* Cargamos la GDT y activamos modo protegido. */

    /* LGDT recibe la dirección de gdt_descriptor, una
     * estructura de 6 bytes con el tamaño y la dirección
     * de la GDT. Con esto el procesador sabe dónde buscar
     * los descriptores cuando necesite traducir selectores.
     */
    lgdt gdt_descriptor

    /* Activar modo protegido seteando el bit PE (bit 0)
     * del registro de control CR0.
     */
    mov %cr0, %eax
    orl $0x1, %eax
    mov %eax, %cr0

    /* Far jump: hace dos cosas simultáneamente.
     * 1. Carga CS con el selector CODE_SEG (0x08),
     *    apuntando al descriptor de código de la GDT.
     * 2. Vacía el pipeline del procesador, que puede
     *    tener instrucciones de 16 bits prefetcheadas
     *    que serían mal interpretadas en 32 bits.
     * Sin este jump el procesador podría comportarse
     * de forma impredecible al entrar a protected_mode.
     */
    ljmp $CODE_SEG, $protected_mode

/* GDT (Global Descriptor Table)
 * Tres entradas: null, código, datos.
 * Ambos segmentos usan modelo flat: base=0, límite=4GB.
 * Esto significa que código y datos pueden acceder
 * a toda la memoria sin restricciones de segmento.
 */
 gdt_start:

/* Descriptor 0: NULO
 * Requerido por la arquitectura x86. El procesador
 * reserva esta entrada y usarla genera una #GP.
 * Siempre debe estar en cero.
 */
gdt_null:
    .long 0x0
    .long 0x0

/* Descriptor 1: Segmento de CÓDIGO (CODE_SEG = 0x08)
 *   Base:  0x00000000
 *   Límite: 0xFFFFF × 4KB = 4GB (G=1)
 *   Access: P=1, DPL=00, S=1, E=1, DC=0, RW=1, A=0
 *     P=1   → segmento presente en memoria
 *     DPL=0 → ring 0 (kernel)
 *     S=1   → segmento de código/datos (no sistema)
 *     E=1   → ejecutable (es código)
 *     DC=0  → no conforming
 *     RW=1  → legible
 *     A=0   → accessed (la CPU lo setea sola)
 *   Flags: G=1, DB=1, L=0, AVL=0
 *     G=1   → granularidad en páginas de 4KB
 *     DB=1  → segmento de 32 bits
 */
gdt_code:
    .word 0xffff        /* Limit[15:0]            */
    .word 0x0           /* Base[15:0]             */
    .byte 0x0           /* Base[23:16]            */
    .byte 0b10011010    /* Access byte            */
    .byte 0b11001111    /* Flags[7:4] + Limit[19:16] */
    .byte 0x0           /* Base[31:24]            */

/* Descriptor 2: Segmento de DATOS (DATA_SEG = 0x10)
 *   Base y límite identicos al de código.
 *   Access: P=1, DPL=00, S=1, E=0, DC=0, RW=1, A=0
 *     E=0   → no ejecutable (es datos)
 *     RW=1  → escribible
 */
gdt_data:
    .word 0xffff        /* Limit[15:0]            */
    .word 0x0           /* Base[15:0]             */
    .byte 0x0           /* Base[23:16]            */
    //.byte 0b10010010    /* Acces byte            */
    .byte 0b10010000    /* Access byte con solo lectura*/
    .byte 0b11001111    /* Flags[7:4] + Limit[19:16] */
    .byte 0x0           /* Base[31:24]            */

gdt_end:

/* Estructura de 6 bytes que lee LGDT:
 *   .word → tamaño de la GDT en bytes menos 1
 *   .long → dirección lineal donde empieza gdt_start
 */
gdt_descriptor:
    .word gdt_end - gdt_start
    .long gdt_start

/* Código de 32 bits en modo protegido.*/

.code32

protected_mode:
    /* Cargar todos los registros de segmento de datos
     * con DATA_SEG. Esto es OBLIGATORIO: después del
     * far jump CS tiene CODE_SEG, pero DS, ES, SS, FS
     * y GS todavía tienen valores de modo real que en
     * modo protegido son selectores inválidos.
     * El procesador usa un caché interno (descriptor cache)
     * para cada registro de segmento. Al escribir el
     * selector, el procesador busca el descriptor en la
     * GDT y carga base, límite y atributos en ese caché.
     */
    mov $DATA_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    /* Intento de escritura en segmento de solo lectura.
     * Esto debería disparar una #GP inmediatamente.
     * El procesador detecta la violación antes de ejecutar
     * la instrucción y genera la excepción.
     */
    mov $0x42, %al
    mov %al, (%edi)     /* acá se dispara la #GP */

    /* Reubicar la pila en una zona segura*/
    mov $0x7000, %ebp
    mov %ebp, %esp

     /* Imprimir en la memoria de video VGA.
     * La BIOS (int 0x10) ya NO está disponible en modo
     * protegido porque es código de 16 bits que requiere
     * modo real. En cambio, escribimos directamente en el
     * buffer de texto VGA mapeado en 0xB8000.
     *
     * Formato de cada celda (2 bytes por carácter):
     *   Byte par:   código ASCII
     *   Byte impar: atributo de color
     *     bits 7-4: color de fondo (0000 = negro)
     *     bits 3-0: color de texto (1111 = blanco brillante)
     *   0x0f = blanco brillante sobre negro
     */
    mov $0xb8000, %edi  /* puntero al buffer VGA     */
    mov $message, %esi  /* puntero al string         */
    mov $0x0f, %ah      /* atributo de color         */

print_loop:
    /* LODSB carga el byte apuntado por DS:ESI en AL
     * e incrementa ESI automáticamente.
     */
    lodsb

    /* Si AL == 0 llegamos al null terminator, terminamos. */
    test %al, %al
    jz done

    /* Escribimos carácter y atributo en el buffer VGA. */
    mov %al, (%edi)     /* ASCII en byte par         */
    mov %ah, 1(%edi)    /* color en byte impar       */
    add $2, %edi        /* avanzar a la celda siguiente */
    jmp print_loop

done:
    cli
    hlt

message:
    .asciz "Hello World! Grupo git push & pray"

