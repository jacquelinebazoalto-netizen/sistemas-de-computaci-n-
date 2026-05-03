# Laboratorio N° 3: "Modo Real vs. Modo Protegido"

## UEFI y Coreboot

### ¿Qué es UEFI? ¿como puedo usarlo? Mencionar además una función a la que podría llamar usando esa dinámica.
---

UEFI (Unified Extensible Firmware Interface) es una especificación de firmware moderna que reemplaza al BIOS tradicional. Actúa como una capa intermedia entre el hardware y el sistema operativo, encargándose de la inicialización del sistema y del proceso de arranque.
Es el software que arranca la computadora antes del sistema operativo.
Define cómo interactúan: el hardware,el firmware y el sistema operativo

A diferencia del BIOS, UEFI posee una arquitectura modular, soporte para discos grandes (GPT), interfaz gráfica y capacidades de seguridad avanzadas.

Se puede utilizar accediendo al menú de firmware durante el arranque del sistema (teclas como F2, DEL o ESC). Desde allí es posible:
- Configurar el orden de booteo
- Habilitar o deshabilitar dispositivos
- Gestionar opciones de seguridad
- Configurar parámetros de hardware

Una función importante accesible mediante esta interfaz es Secure Boot, que permite verificar criptográficamente la integridad del sistema operativo antes de su ejecución, evitando la carga de software no autorizado o malicioso.

Se puede usar a través de:
Aplicaciones UEFI
Drivers UEFI
Bootloaders
Todos estos interactúan usando:
Boot Services
Runtime Services
La dinámica de uso de UEFI consiste en acceder a la UEFI System Table, que es la estructura principal desde donde el firmware expone sus servicios. A partir de esta tabla, se obtienen punteros a distintas funciones organizadas en Boot Services y Runtime Services. Utilizando estos punteros, el programa puede invocar funciones del firmware para realizar diversas tareas, como manejar memoria, cargar aplicaciones o interactuar con dispositivos, todo dentro del entorno previo al sistema operativo.

### Funcion Ejemplo:
Un ejemplo de función importante dentro del entorno UEFI es LoadImage(). Esta función se utiliza para cargar en memoria una imagen ejecutable UEFI, como puede ser un bootloader o una aplicación. Su uso permite preparar el programa para su posterior ejecución, facilitando así el proceso de arranque del sistema o la ejecución de herramientas en la etapa previa al sistema operativo.


### Casos de bugs de UEFFI que puedes ser explotados
---

Un caso de vulnerabilidad en UEFI mencionado en el documento es el S3 Resume Boot Script Attack. Este ocurre durante la reanudación del sistema desde el estado de suspensión (S3), donde el firmware utiliza un “boot script” previamente generado para reconfigurar rápidamente el hardware. Si este script no está adecuadamente protegido, un atacante puede modificarlo o alterar sus punteros, logrando así la ejecución de código arbitrario en una etapa muy temprana del arranque, comprometiendo la seguridad del sistema.
Además, existen otros posibles bugs en UEFI, como el Secure Boot Bypass, que ocurre cuando fallas en la verificación de firmas digitales permiten ejecutar software no autorizado, y los ataques a drivers UEFI, donde controladores maliciosos pueden cargarse si no se implementan correctamente los mecanismos de validación. Estas vulnerabilidades son críticas debido a que afectan una capa fundamental del sistema, permitiendo incluso persistencia a nivel de firmware.

Existen múltiples vulnerabilidades en UEFI que han sido explotadas. Un caso relevante es el de equipos Lenovo con fallas como:

- CVE-2021-3971 y CVE-2021-3972: permiten modificar variables NVRAM y desactivar protecciones como Secure Boot.
- CVE-2021-3970: permite ejecución de código con privilegios elevados.

Estos bugs permiten instalar bootkits, malware que se ejecuta antes del sistema operativo, como:

- MosaicRegressor
- Lojax

Este tipo de ataques es particularmente peligroso porque:

- Se ejecuta antes del sistema operativo
- Puede persistir incluso después de reinstalar el sistema
- Es difícil de detectar con herramientas tradicionales

### ¿Qué es Converged Security and Management Engine (CSME), the Intel Management Engine BIOS Extension (Intel MEBx).?
---

El Converged Security and Management Engine (CSME) es un subsistema integrado en los chipsets de Intel que funciona como un microcontrolador independiente dentro de la plataforma. Opera de manera separada del procesador principal y del sistema operativo, y se encarga de funciones relacionadas con la seguridad, la gestión remota y el arranque del sistema. Entre sus tareas se incluyen la verificación de integridad del firmware, la ejecución de funciones criptográficas y el soporte de tecnologías como Intel Active Management Technology (AMT), permitiendo administrar equipos incluso cuando están apagados o sin sistema operativo activo.

Se encarga de:

- Seguridad (Boot Guard, TPM, DRM)
- Inicialización del hardware
- Gestión remota (Intel AMT)

Por otro lado, el Intel Management Engine BIOS Extension (Intel MEBx) es una interfaz de configuración accesible desde el BIOS/UEFI que permite al usuario o administrador configurar las funcionalidades del Management Engine. A través de MEBx se pueden establecer parámetros como la configuración de red, credenciales de acceso y opciones de administración remota. 
En conjunto, CSME y MEBx forman parte de la infraestructura de gestión y seguridad de las plataformas Intel, operando a un nivel muy bajo dentro del sistema.
Opera incluso cuando el sistema está apagado.

### ¿Qué es coreboot ? ¿Qué productos lo incorporan ?¿Cuales son las ventajas de su utilización?
---

Coreboot es un proyecto de firmware de código abierto que reemplaza al BIOS o UEFI tradicional en una computadora. Su función principal es inicializar el hardware del sistema de la manera más rápida y simple posible, para luego transferir el control a un programa de arranque más completo, como un bootloader o incluso directamente a un sistema operativo. 
A diferencia de las soluciones propietarias, coreboot permite acceso y modificación de su código, lo que lo hace altamente flexible y adaptable.
### Productos que lo incorporan

Este firmware es utilizado en diversos productos, especialmente en dispositivos que priorizan seguridad, transparencia o personalización. 
Por ejemplo, es empleado en algunas computadoras portátiles de fabricantes como Google (Chromebooks), en servidores, sistemas embebidos y equipos especializados donde se requiere control total del firmware.

### Ventajas de utilización

Entre las principales ventajas de coreboot se encuentran su rapidez de arranque, ya que inicializa solo el hardware necesario; su carácter de código abierto, que permite auditorías de seguridad y modificaciones; y su flexibilidad, al poder adaptarse a distintas plataformas y necesidades específicas. 
Además, reduce la dependencia de firmware propietario, lo cual es importante en entornos donde la seguridad y la confianza en el sistema son críticas.

Otras ventajas:

- Código abierto → mayor auditabilidad y transparencia
- Menor tamaño → reducción de la superficie de ataque
- Arranque significativamente más rápido
- Alta flexibilidad mediante payloads personalizados
- Diseño minimalista que mejora la seguridad (menor complejidad)

### Hello World: Compilar y Linkear

Comenzaremos instalando las dependencias necesarias en la distribución de Linux, Fedora:
```bash
sudo dnf install binutils qemu-system-x86 nasm
```

`binutils` nos da el `as` (ensamblador GNU), `ld` (linker), `objdump` y `hd/hexdump`. `qemu-system-x86` es el emulador.


Ahora crearemos los archivos en el directorio [bootloader](/trabajo3/bootloader/).
Tendremos los archivos: [main.S](/trabajo3/bootloader/main.S) y [link.ls](/trabajo3/bootloader/link.ld).

Y ahora vamos a compilar y linkear el hello world

1. Ensamblar: Generar el object file con debug info
   ![ensamlar-obj-file](/trabajo3/img/1obj-file-main.png)

2. Linkear: Generar imagen binaria raw
   ![linkear](/trabajo3/img/2linker.png)

Notar que `main.img` pesa exactamente **512 bytes**, que es el tamaño exacto de un sector MBR. Esto es importante porque la firma de arranque `0x55 0xAA` debe estar en los bytes 510 y 511 (offsets 0x1FE y 0x1FF). La BIOS lee el primer sector del disco, va directo a esos dos offsets específicos, y si no encuentra `55 AA` ahi, declara que el dispositivo no es booteable y ni lo intenta ejecutar.
La BIOS solo lee exactamente 512 bytes (un sector) y los carga en `0x7C00`.

## Linker

### ¿Que es un linker? ¿que hace?
---

Un linker es una herramienta que combina uno o más archivos objeto (.o) generados por el compilador en un solo archivo ejecutable o binario. 
Resuelve referencias a funciones o variables entre los distintos archivos.

Sus funciones principales son:

- Une archivos objeto en un ejecutable
- Resuelve símbolos (funciones/variables)
- Reubica direcciones en memoria
- Organiza secciones (.text, .data)

¿Qué hace el Linker?

- Asigna direcciones de memoria a las instrucciones y datos.
- Resuelve direcciones de etiquetas.
- Agrupa las diferentes secciones (.text, .data, .bss) de manera coherente.


### ¿Que es la dirección que aparece en el script del linker?¿Porqué es necesaria?
---

Es la dirección de memoria donde se ubicará el programa al ejecutarse. Es necesaria porque la BIOS carga el bootloader en esa dirección. El linker debe saberlo para calcular correctamente saltos y accesos a memoria.
Es necesaria porque:

- La BIOS carga el bootloader en una dirección fija (0x7C00)
- El código debe coincidir con esa ubicación para que los saltos y referencias sean correctos

Sin esta información, el programa no funcionaría correctamente debido a errores en direccionamiento.

### Compare la salida de objdump con hd, verifique donde fue colocado el programa dentro de la imagen. 
---

Vamos a correr las herramientas `objdump` y `hd`, y comparar las salidas.

Corremos `objdump` sobre el object file:
![ejecucion-objdumo](/trabajo3/img/3ejecucion-objdump.png)

Corremos `hd` sobre la imagen binaria:
![ejecucion-hd](/trabajo3/img/4-ejecucion-hd.png)

**Nota**: `hd` es un alias de `hexdump -C`.

**Análisis del** `objdump` **sobre** `main.o`:

En la primera línea
```
0:   be 00 00 b4 0e    mov esi, 0xeb40000
```
Hay dos cosas importantes para notar acá:
- Primero, `objdump` está interpretando el código como 64 bits, porque el `.o` es formato `elf64-x86-64`. Por eso se ve `be 00 00 b4 0e` como una sola instrucción de 5 bytes que carga `0xeb40000` en `ESI`. Eso es una interpretación incorrecta del disassembler, porque en realidad son dos instrucciones de 16 bits:
    ```
    be 00 00   →   mov si, 0x0000    (3 bytes)
    b4 0e      →   mov ah, 0x0e      (2 bytes)
    ```
- Segundo, `si` recibe `0x0000`. Esa es la relocation pendiente. El ensamblador no sabe donde va a quedar `msg` en memoria, asi que deja ceros como placeholder y "le dice" al linker que ahi va la dirección real de `msg`. Si ejecutaramos este código así, `si` apuntaría a la dirección `0x0000` y el programa imprimiría basura o crashearía.

El resto del código en el `.o` tiene direcciones relativas a cero: `loop` en `0x5`, `halt` en `0xe`, `msg` en `0xf`. Estas no son las direcciones reales de ejecución, son solo offsets dentro del archivo objeto.

**Análisis del** `hexdump` **sobre** `main.img`:
La primera línea ya muestra el resultado del trabajo del linker
```
00000000   be 0f 7c  b4 0e  ac  08 c0  74 04  cd 10  eb f7  f4  68
```
Ahora `be 0f 7c` significa `mov si, 0x7c0f`. El linker resolvió la relocation: tomó la base `0x7c00` que se le indico en el [script](/trabajo3/bootloader/link.ld), le sumo el offset de `msg` dentro del código (`0x0f`), y metió `0x7c0f` en esos dos bytes. Esa es la dirección correcta donde va a estar `msg` en RAM cuando la BIOS cargue el sector.

La segunda línea confirma el string:
```
00000010   65 6c 6c 6f 20 77 6f 72 6c 64 00 ...    |ello world...|
```
Junto con el `68` del final de la primera línea se forma `68 65 6c 6c 6f 20 77 6f 72 6c 64 00` -> `"hello world\0"` en ASCII. El `00` al final es el null terminator que usa el `jz halt` para saber cuándo parar de imprimir.

Y lo más importante se puede ver en la última línea:
```
000001f0   00 66 2e 0f 1f 84 00 00  00 00 0f 1f 00 55 aa    |...........U.|
00000200
```
Los bytes `55 aa` están en los offsets `0x1fe` y `0x1ff`, exactamente donde la BIOS los espera. El archivo termina en `0x200 = 512 bytes`, por lo tanto esta todo correcto.

**Grabado de pendrive y prueba en PC real**:

![grabado-pendrive](/trabajo3/img/grabado-pendrive.png)

A pesar de que todo pareciera indicar que se grabó correctamente la imagen en el pendrive, al intentar ejecutarlo en distintas PCs (tres PCs distintas) no logramos ver el "hello world". Sin embargo si se lograba ver un guión "_" itermitente, que por lo que pudimos averiguar esto significa que la BIOS si encontró la firma `55 AA`, cargo el sector en `0x7C00` y saltó a ejecutarlo. El problema es que el código corre pero no imprime nada. El problema es que el valor de `DS` al arrancar depende de la BIOS, y cada BIOS lo deja en un valor distinto. Algunas lo dejan en `0`, otras en `0x07C0`, otras en cualquier cosa.
Con ayuda de la IA nos dio variantes del código de [main.S](/trabajo3/bootloader/main.S) para que se pueda ejecutar, pero ninguna funcionó y ya sentíamos que estabamos modificando sin entender.

Decidimos volver al código original que si conocemos y probar la ejeción con QEMU:

![imagen-qemu](/trabajo3/img/ejecucion-imagem-qemu.png)

QEMU es un emulador de hardware completo que simula por software una PC x86 completa, incluyendo una BIOS tradicional (SeaBIOS).
Y para este caso si nos funcionó y pudimos ver el `"hello world"`.


### ¿Para que se utiliza la opción --oformat binary en el linker?
---

Se usa para generar un binario puro, sin encabezados.

Sirve para:

Bootloaders
Sistemas embebidos
Carga directa en memoria

### ¿Para que se utiliza la opción --oformat binary en el linker?
---

Se utiliza para generar un archivo binario puro (sin cabeceras de formato ELF u otros) que pueda ser cargado directamente por el BIOS o un emulador.


### Depuración con gdb dashboard
---

Cuando QEMU arranca el `main.img`, emula exactamente lo que haría una PC real: la BIOS carga el primer sector del disco (512 bytes) en la dirección física 0x7C00 de RAM y le transfiere el control. El código vive ahi, en modo real de 16 bits.

Lanzando QEMU con el stub de GDB:

![qemu-gdb](/trabajo3/img/ejecucion-qemu.png)

utilizamos el comando

```bash
qemu-system-i386 -fda main.img -boot a -s -S -monitor stdio
```

Para conectar `gdb`:
1. En otra terminal ejecutamos `gdb source ~/.gdbinit`
2. Nos conectamos a stub de QEMU con `(gdb) target remote localhost:1234`
3. Le decimos a GDB que estamos en 16 bits con `(gdb) set architecture i8086`. Por defecto, GDB asume que el código es de 32 o 64 bits y va a desensamblar mal. Con esto le decimos que estamos en modo real de 16 bits (i8086).

![inicializacion-gdb](/trabajo3/img/inicializacion-gdb.png)

Notemos que aparece
```
Remote debugging using localhost:1234
0x0000fff0 in ?? ()
```

La dirección 0x0000fff0 es donde el procesador x86 siempre empieza: el reset vector. Es el último punto de la memoria antes del tope del espacio de direcciones (es un jump a la BIOS).

Vamos a agregar un breakpoint en la dirección de arranque del bootloader.
```
(gdb) br *0x7c00
```

Con esto le decimos a GDB que pause cuando la ejecución llegue a `0x7C00`. Esta es la dirección donde la BIOS carga y ejecuta el bootloader.

Para continuar con el breakpoint:

```
(gdb) c
```

![primer-breakpoint-y-continue](/trabajo3/img/primer-br-y-c.png)

QEMU "descongela" la CPU, la BIOS hace su trabajo (inicializa hardware, busca dispositivo booteable, carga el sector), y cuando llega a `0x7c00` GDB congela la ejecución nuevamente.

No podemos poner un breakpoint directamente en `int $0x10` porque cuando GDB intenta hacer `si` dentro de una interrupción de BIOS, entra al código de la BIOS (que está en ROM/memoria emulada), y eso es un laberinto: código sin símbolos, en modo real, que puede durar cientos de instrucciones. GDB puede perderse o comportarse raro.

Pondremos un breakpoint en la instrucción anterior o siguiente a `int $0x10`, para que cuando la interrupción termine y la BIOS devuelva el control, GDB pause ahí y podamos ver el efecto.

Para encontrar las direcciones tenemos que desensamblar el código desde `0x7c00`:
```
(gdb) x/20i 0x7c00
```

![desensamblado-y-direcciones](/trabajo3/img/desensamblado-direcciones.png)

Si lo queremos ubicar antes debemos poner el breakpoint en la dirección `0x7c08`

![ejecucion-con-br](/trabajo3/img/ejecucion-con-br.png)

Dandole continue `c` se va ejecutando y mostrando el caracter en QEMU.


## Modo Protegido

### Código en assembler que pueda pasar a modo protegido
---

Para realizar este punto, escribimos el código en ensamblador [main_pm.S](/trabajo3/bootloader/main_pm.S), basándonos en el código ya realizado en el repositorio de GitHub, en específico el archivo [common.h](https://github.com/cirosantilli/x86-bare-metal-examples/blob/master/common.h#L135), más información obtenida de internet y con ayuda en explicaciones por parte de la IA. Aclaramos que si bien utilizamos IA, nos comprometimos a aprender y entender todo lo que hicimos. Tratamos a la IA como una herramienta más.

En el código se realizaron comentarios que describen el proceso.

Para corroboroar que el código es correcto, y que en efecto logramos pasar al modo protegido, compilamos y linkeamos con el mismo linker [link.ld](/trabajo3/bootloader/link.ld), y ejecutamos en QEMU:

![compilacion-pm](/trabajo3/img/compilacion_protec_mode.png)

> Notar que verificamos el tamaño de 512 bytes

Ejecución con qemu:

![ejecucion-qemu-pm](/trabajo3/img/ejecucion-modo-protegido.png)


### ¿Cómo sería un programa que tenga dos descriptores de memoria diferentes, uno para cada segmento (código y datos) en espacios de memoria diferenciados?
---

Para que un programa tenga los descriptores de código y datos en espacios de memoria deiferenciados hay que cambiar los campos base de los descriptores de la GDT. El resto del programa queda igual.

Para fijar las bases distintas:
- Segmento de código -> base `0x00008000`
- Segmento de datos -> base `0x00002000`
- Límite de cada -> `0xFFFF` con `G=0` (granularidad en bytes, no en páginas), para que sean zonas acotadas y diferenciadas.


La modificación en la GDT sería lo siguente:
```asm
gdt_code:
    .word 0xffff        /* Limit[15:0]   = 0xFFFF (64KB)          */
    .word 0x8000        /* Base[15:0]    = 0x8000  ← cambió       */
    .byte 0x00          /* Base[23:16]   = 0x00                   */
    .byte 0b10011010    /* Access byte   (igual que antes)         */
    .byte 0b01001111    /* Flags+Limit:  G=0 ← cambió, DB=1, L=0  */
    .byte 0x00          /* Base[31:24]   = 0x00                   */

gdt_data:
    .word 0xffff        /* Limit[15:0]   = 0xFFFF (64KB)          */
    .word 0x0000        /* Base[15:0]    = 0x0000                 */
    .byte 0x02          /* Base[23:16]   = 0x02  ← acá está el 0x02 de 0x00020000 */
    .byte 0b10010010    /* Access byte   (igual que antes)         */
    .byte 0b01001111    /* Flags+Limit:  G=0 ← cambió, DB=1, L=0  */
    .byte 0x00          /* Base[31:24]   = 0x00                   */
```

El único flag que cambió en el código anterior es G (Granularity), que pasó de 1 a 0. Con `G=1` el límite se multiplica por 4KB, entonces `0xFFFF × 4KB = 4GB`. Con `G=0` el límite está en bytes directamente, entonces `0xFFFF = 64KB`. Eso es lo que nos permite tener segmentos acotados y diferenciados en el mapa de memoria.

Lo importante para entender acá es que **en modo protegido una dirección lógica no es una dirección física**. Cuando el código hace `mov %ax, (%edi)` con `DS` cargado con el selector de datos, el procesador calcula:
```
dirección física = base del segmento (del descriptor en la GDT) + offset (EDI)
                = 0x00020000 + EDI
```
El mismo offset `0x0000` en `CS` apunta a `0x8000` en memoria física, y ese mismo offset en `DS` apunta a `0x20000`. Dos espacios completamente diferenciados por hardware.


### Cambiando los bits de acceso al segmento de datos para que sea solo lectura e intentando escribir en el
---

Cuando el procesador en modo protegido detecta una violación de los atributos de un segmentos (intenta escribir en uno de solo lectura), genera una excepción #GP (General Protection Fault). **Esta es una excepción de tipo fault, lo que quiere decir que el procesador la detecta antes de ejecutar la instrucción que la causa**.

Para manejar una #GP el procesador busca su handler en la IDT (Interrupt Descriptor Table), que es el equivalente en modo protegido de la IVT de modo real. Pero en nuestro caso no tenemos ninguna IDT configurada. Entonces ocurriría lo siguiente:

1. Intento de escritura en segmento RO (Read-Only)
2. Procesador genera #GP
3. Busca handler en IDT -> IDT no existe / inválida
4. Procesador genera #DF - Double Fault
5. Busca handler de #DF en IDT -> tampoco existe
6. Triple fault -> el procesador se resetea completamente

En QEMU deberíamos ver que la máquina virtual se resetea sola o se congela. Y con GDB vamos a poder pausar la ejecución justo antes del reset y ver en que instrucción ocurre.

El bit que controla si un segmento de datos es escribible es el bit 1 (RW) del access byte:
```
Access byte actual (escribible):   0b10010010  = 0x92
                                         ↑
                                      RW=1 (writable)

Access byte nuevo (solo lectura):  0b10010000  = 0x90
                                         ↑
                                      RW=0 (read-only)
```

Esto se debe modificar en el `gdt_data` del [main_pm.S](/trabajo3/bootloader/main_pm.S).
Y en el código de 32 bits se agrega un intento de escritura explícito para disparar la excepción. Lo pondremos después de configurar los segmentos y antes del print loop.

Para verlo lanzaremos dos terminales, en una tendremos QEMU pausado, y en la otra ejecutaremos GDB. Pero para saber donde poner el breakpoint tenemos que calcular la dirección. Para esto utilizaremos la herrmienta `nm` que nos mostrará las direcciones:

![inicio-y-nm](/trabajo3/img/incio-escritura-en-solo-lectura.png)

`nm` es una herramiento del paquete **binutils** (el mismo que tiene `objdump`, `ld`, `as`) que lista los **símbolos** contenidos en un archivo u objeto ejecutable. Un símbolo es un nombre con una dirección asociada: etiquetas de funciones, variables globales, *etiquetas de ensamblador*, constantes, etc. 
En nuestro caso lo usamos para encontrar el offset de `protected_mode` dentro de `.o`, porque el linker coloca todo a partir de `0x7c00`, pero el `.o` tiene las direcciones relativas a cero. Con `nm` vemos que `protected_mode` está en offset `0x3f`, y sabiendo que la BIOS carga el código en `0x7c00`, calculamos que en memoria real va a estar en `0x7c3f`, y ahí es donde pondremos el breakpoint.

La salida de `nm` también indica el tipo. El tipo `t` indica que el símbolo está en la sección .`text` (código). Otros tipos comunes son `d` para `.data`, `b` para `.bss` y a para símbolos absolutos como `CODE_SEG` y `DATA_SEG`.

Vamos a ejecutar tres `si` seguidos de `info registers`:

![](/trabajo3/img/gdb-wInRO1.png)
![](/trabajo3/img/gdb-wInRO2.png)
![](/trabajo3/img/gdb-wInRO3.png)
![](/trabajo3/img/gdb-wInRO4.png)

`info registers` da mucha información, pero nos centramos en lo siguiente:
- `RIP`: que instrucción está por ejecutarse (la dirección).
- `CS`, `DS`, `SS`, `ES`, `FS`, `GS`: los selectores de segmento.
- `RAX`: donde esta el valor que vamos a intentar escribir.
- `CR0`: para confirmar que PE está activo (modo protegido).

Analizando lo obtenido en estas primeras tres iteraciones:

Al entrar a `protected_mode` (`0x7c3f`):

```
cs  = 0x8   ← CODE_SEG, correcto, cargado por el far jump
ds  = 0x0   ← todavía sin cargar
cr0 = 0x11  ← bit PE activo, estamos en modo protegido 
```

Después del primer `si` (`0x7c43`):
```
rax = 0x10  ← mov $DATA_SEG, %ax ejecutado, AX tiene el selector
ds  = 0x0   ← todavía no se cargó DS
```

Después del siguiente `si` (`0x7c45`):
```
ds  = 0x10  ← mov %ax, %ds ejecutado, DS ya tiene DATA_SEG 
```
Para avanzar hasta la instrucción `mov %al, (%rdi)` que es la escritura ilegal, hacemos `disassemble $rip, +30` para saber las instrucciones que viene:

![](/trabajo3/img/prox-instruc.png)

La instrucción problemática es:

```
0x7c4f:  mov %al,(%rdi)   <- acá ocurre la #GP
```

Si actualmente estamos en `0x7c45`, necesitamos hacer 4 `si` para llegar justo antes de esa instrucción:

![](/trabajo3/img/salto-RIP.png)

Ocurrió algo interesante y distinto a lo esperado pero igual de válido. La #GP ya se disparó, pero no donde esperábamos. Ocurrió en `0x7c4b` que es el `mov %eax,%ss`, no en la escritura explícita. El RIP saltó a `0xe05b` que es la zona de ROM del BIOS de QEMU, lo que indica que ocurrió el triple fault y el procesador se reseteó.

El procesador rechazó cargar el selector de datos en SS porque SS siempre debe apuntar a un segmento escribible. Es una restricción de la arquitectura x86: no tiene sentido tener una pila en un segmento de solo lectura porque PUSH y POP necesitan escribir. El procesador lo detecta en el momento de cargar el selector, antes incluso de intentar cualquier escritura.

Haciendo `info registers` justo despues que salte a esta dirección vemos que:

Antes de la #GP (cuando RIP estaba en 0x7c4b):
```
cr0 = 0x11        -> bit PE activo, estábamos en modo protegido
cs  = 0x8         -> CODE_SEG
ds  = 0x10        -> DATA_SEG (solo lectura)
rip = 0x7c4b      -> apuntando a nuestro código
```

Después del triple fault (RIP en 0xe05b):

```
cr0 = 0x60000010  -> PE apagado (bit 0 = 0), volvió a modo real
cs  = 0xf000      -> segmento de ROM del BIOS
rip = 0xe05b      -> dentro de la ROM del BIOS
ds  = 0x0         -> todos los segmentos reseteados
ss  = 0x0
rax = 0x0         -> todos los registros generales reseteados
```

`CR0` pasó de `0x11` a `0x60000010`: el bit `PE` (bit 0) se apagó. El procesador salió de modo protegido y volvió a modo real como consecuencia del triple fault. Eso confirma el reset completo.

`CS:RIP` pasó a `0xf000:0xe05b`: esta es la dirección de reset del procesador x86 (0xFFFF0 en modo real), que es donde está el vector de reset de SeaBIOS. El procesador reinició desde cero como si acabara de encenderse.

En conclusión, al intentar cargar el selector de solo lectura en SS, el procesador generó una #GP. Sin IDT configurada, escaló a #DF y luego a triple fault, lo que se evidencia en GDB por el salto del RIP a la ROM del BIOS y el bit PE de CR0 apagándose, indicando que el procesador se reseteó completamente y abandonó el modo protegido.


### En modo protegido, ¿Con qué valor se cargan los registros de segmento ? ¿Por qué?

---

En modo protegido los registros de segmento (`CS`, `DS`, `SS`, `ES`, `FS`, `GS`) se cargan con un selector, no con una dirección directa como en modo real.

Un selector es un valor de 16 bits con la siguiente estructura:

- bits 15-3: Índice. Qué entrada de la tabla de descriptores usar. Como cada descriptor ocupa 8 bytes, la dirección del descriptor = índice × 8.
- bits 3-2: TI. Qué tabla usar. 0 = GDT, 1 = LDT.
- bits 1-0: RPL. Requested Privilege Level, el nivel de privilegio con el que se solicita el acceso (0=kernel, 3=usuario).

En modo protegido el registro de segmento ya no contiene una dirección sino una referencia a un descriptor. Cuando escribimos un selector en `DS` por ejemplo, el procesador automáticamente va a la `GDT`, busca la entrada en el índice indicado, y carga en su caché interno invisible (el descriptor cache) la base, el límite y los atributos de ese segmento. A partir de ahí, cada acceso a memoria a través de `DS` usa esa información cacheada para:

- Verificar que el offset no supere el límite del segmento.
- Verificar que el nivel de privilegio sea compatible.
- Verificar que el tipo de acceso sea permitido (lectura/escritura/ejecución).
- Calcular la dirección física = base del descriptor + offset.

Eso es exactamente lo que vimos en el código que realizamos:
```asm

mov $DATA_SEG, %ax
mov %ax, %ds
mov %ax, %es
mov %ax, %fs
mov %ax, %gs
mov %ax, %ss
```
Cada uno de esos `mov` hace que el procesador consulte la `GDT`, valide el selector y cargue el descriptor cache correspondiente. Si no hiciéramos esto después del far jump, los registros de segmento seguirían teniendo valores de modo real que en modo protegido serían interpretados como selectores inválidos, generando una #GP en el primer acceso a memoria.

## Conclusión

El trabajo muestra cómo funciona el sistema desde el arranque a muy bajo nivel:

UEFI y BIOS controlan el inicio del sistema
El linker permite construir ejecutables correctamente ubicados en memoria
El modo protegido introduce seguridad y control de memoria mediante segmentación
coreboot y tecnologías como CSME muestran la evolución del firmware moderno

En conjunto, se entiende cómo el hardware, firmware y software interactúan desde el primer ciclo de ejecución hasta el sistema operativo.