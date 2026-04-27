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
