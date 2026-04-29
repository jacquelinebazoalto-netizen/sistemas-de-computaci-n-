# Laboratorio N° 3: "Modo Real vs. Modo Protegido"

## UEFI y Coreboot

### ¿Qué es UEFI? ¿como puedo usarlo? Mencionar además una función a la que podría llamar usando esa dinámica.
---
<- BORRAR Y RESPONDER ACÁ->

### Casos de bugs de UEFFI que puedes ser explotados
---
<- BORRAR Y RESPONDER ACÁ->

### ¿Qué es Converged Security and Management Engine (CSME), the Intel Management Engine BIOS Extension (Intel MEBx).?
---
<- BORRAR Y RESPONDER ACÁ->

### ¿Qué es coreboot ? ¿Qué productos lo incorporan ?¿Cuales son las ventajas de su utilización?
---
<- BORRAR Y RESPONDER ACÁ->


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
<- BORRAR Y RESPONDER ACÁ->


### ¿Que es la dirección que aparece en el script del linker? ¿Por qué es necesaria?
---
<- BORRAR Y RESPONDER ACÁ->

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

### Depuración con gdb dashboard

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



### ¿Para que se utiliza la opción --oformat binary en el linker?
---
<- BORRAR Y RESPONDER ACÁ->


## Modo Protegido

### Código en assembler que pueda pasar a modo protegido
---
<- BORRAR Y RESPONDER ACÁ->

### ¿Cómo sería un programa que tenga dos descriptores de memoria diferentes, uno para cada segmento (código y datos) en espacios de memoria diferenciados?
---
<- BORRAR Y RESPONDER ACÁ->

### Cambiando los bits de acceso al segmento de datos para que sea solo lectura
---
<- BORRAR Y RESPONDER ACÁ->

### En modo protegido, ¿Con qué valor se cargan los registros de segmento ? ¿Por qué?
---
<- BORRAR Y RESPONDER ACÁ->

## Conclusión
