# Trabajo Práctico 1: Exploración del entorno UEFI y la Shell

### Arranque del entorno virtual
---

![inicio-de-qemu-con-ovmf](/trabajo3/img/inicio-qemu-ovmf.png)

### Exploración de dispositivos 
---

![](/trabajo3/img/comandos-map-dh-ovmf.png)
![](/trabajo3/img/comandoFS0.png)

El comando `FS0:` en la UEFI Shell es equivalente a hacer `cd` hacia un sistema de archivos, pero solo funciona si QEMU tiene algún dispositivo de almacenamiento conectado con una partición FAT32.

`BLK0` es el nombre que la UEFI Shell le asignó al dispositivo. El prefijo `BLK` significa **block device**, es decir, un dispositivo de almacenamiento en bruto al que se puede acceder en bloques de bytes, pero que no tiene un sistema de archivos reconocible montado encima. Por eso no aparece como `FS0:` sino como `BLK0:`. 

**Cómo funcionaba el BIOS legacy**
El BIOS "viejo" operaba con interrupciones de hardware fijas definidas desde los años 80. 
- Si se quería leer del disco, se llamaba a la interrupción `INT 13h`. 
- Si se quería escribir en pantalla, `INT 10h`. 
- Si querías leer el teclado, `INT 16h`. 

Estas interrupciones estaban cableadas a direcciones de memoria físicas fijas, y el código que las implementaba asumía un hardware muy específico: discos IDE con geometría CHS (cilindro/cabeza/sector), tarjetas de video VGA, teclados PS/2, etc.

El problema es que si el hardware no seguía exactamente esa convención, o si era un dispositivo nuevo (USB, NVMe, red), el BIOS simplemente no lo entendía a menos que el fabricante escribiera una extensión propietaria llamada Option ROM, que se cargaba en memoria en direcciones también bastante fijas y era básicamente código sin ninguna estructura de seguridad.

**Cómo lo resuelve UEFI con Handles y Protocolos**:
UEFI introduce una abstracción completamente diferente. En lugar de interrupciones fijas, todo el hardware se representa mediante dos conceptos:
- **Handle**: es simplemente un identificador (un puntero) que representa una entidad, ya sea un dispositivo físico, un driver cargado, una imagen ejecutable, etc. No nos dice nada sobre el hardware en sí, solo es un "nombre" único dentro del sistema.
- **Protocolo**: es una interfaz de software, básicamente una estructura C con punteros a funciones, que define cómo se puede interactuar con algo. Por ejemplo, el protocolo `EFI_BLOCK_IO_PROTOCOL` define funciones como `ReadBlocks()` y `WriteBlocks()`. No importa si el disco es NVMe, SATA, USB o una imagen virtual en QEMU: si el driver correspondiente implementa ese protocolo, cualquier código puede leer del disco usando exactamente la misma interfaz.

Un Handle puede tener múltiples protocolos asociados. Por ejemplo, un dispositivo USB con una partición FAT tendría a la vez el protocolo de block I/O, el protocolo de sistema de archivos, y otros más.

**Ventajas:**
1. **Compatibilidad**: como el firmware habla con los dispositivos a través de protocolos abstractos y no a través de interrupciones fijas, un driver nuevo puede soportar hardware completamente diferente simplemente implementando los mismos protocolos. Se puede arrancar desde NVMe, desde una red, desde USB, desde Thunderbolt, todo con el mismo mecanismo. En el BIOS esto requería hacks y extensiones propietarias.
2. **Seguridad**: En el BIOS, cualquier código que corriera en modo real (incluyendo código malicioso en el MBR) podía llamar directamente a las interrupciones del BIOS y acceder a cualquier hardware sin restricciones. No había ningún control de acceso. En UEFI, para acceder a un protocolo hay que pedírselo explícitamente al Boot Services mediante funciones como `LocateProtocol()` o `HandleProtocol()`. El firmware puede controlar qué código tiene acceso a qué protocolos. Además, existe el mecanismo de Secure Boot, que verifica criptográficamente la firma de cada imagen .efi antes de ejecutarla, algo que era imposible en el modelo de BIOS porque no había ninguna estructura formal de ejecutables, solo código raw en sectores de disco. También está la separación entre Boot Services (disponibles solo durante el arranque) y Runtime Services (disponibles incluso después de que el OS tomó control). Esto limita la superficie de ataque: una vez que el OS llama a ExitBootServices(), la mayoría de los protocolos del firmware dejan de estar disponibles, reduciendo lo que un atacante podría explotar desde el OS.

En resumen, el modelo de Handles y Protocolos convierte a UEFI en algo más parecido a un microkernel orientado a objetos que a un BIOS, con interfaces bien definidas, drivers intercambiables y (cuando está bien configurado) mecanismos de verificación de integridad.


### Análisis de Variables Globales
---

![](/trabajo3/img/comando-dmpstore.png)
![](/trabajo3/img/boot0001_y_bootorder.png)

**Interpretando los resultados**

**La variable `BootOrder`**:

```
Variable NV+RT+BS 'EFIGlobalVariable:BootOrder' DataSize = 0x04
  00000000: 00 00 01 00
```

`DataSize = 0x04` significa 4 bytes. Como cada entrada es un WORD de 16 bits (2 bytes), hay exactamente **2 entradas** en la lista. Leyéndolos en pares little-endian:

- Bytes `00 00` → `0x0000` → **Boot0000** (primera prioridad)
- Bytes `01 00` → `0x0001` → **Boot0001** (segunda prioridad)

Entonces el Boot Manager va a intentar primero `Boot0000`, y si falla, intenta `Boot0001`.



### La variable `Boot0001`

```
Variable NV+RT+BS 'EFIGlobalVariable:Boot0001' DataSize = 0x58
  00000000: 01 00 00 00 2C 00 45 00-46 00 49 00 20 00 49 00
  00000010: 6E 00 74 00 65 00 72-6E 00 61 00 6C 00 20 00
  00000020: 53 00 68 00 65 00 6C-6C 00 ...
```

Desglosando esto último:

**Bytes `01 00 00 00`** -> Atributos. El bit 0 en 1 significa `LOAD_OPTION_ACTIVE`, es decir, esta entrada está **habilitada**. Si fuera `00 00 00 00` el Boot Manager la saltearía.

**Bytes `2C 00`** -> Longitud del FilePathList = `0x002C` = 44 bytes. Le dice al parser dónde termina la ruta del dispositivo y dónde empiezan datos opcionales.

**Los bytes siguientes en pares** son una string Unicode UTF-16LE (cada carácter ocupa 2 bytes). Decodificándolos:
```
45 00 = 'E'
46 00 = 'F'
49 00 = 'I'
20 00 = ' '
49 00 = 'I'
6E 00 = 'n'
74 00 = 't'
65 00 = 'e'
72 00 = 'r'
6E 00 = 'n'
61 00 = 'a'
6C 00 = 'l'
20 00 = ' '
53 00 = 'S'
68 00 = 'h'
65 00 = 'e'
6C 00 = 'l'
6C 00 = 'l'
00 00 = fin de string
```

La descripción es **"EFI Internal Shell"**. Esto es exactamente lo que arranca cuando QEMU inicia: la shell integrada en el firmware OVMF.

Después del null terminator vienen los bytes del Device Path que apuntan al ejecutable `.efi` de la shell dentro del propio firmware (por eso tiene esos GUIDs en los offsets 0x30 y 0x40, son identificadores de la imagen interna).


`BootOrder` dice que primero se intenta `Boot0000`, pero esa variable **no aparece en el dmpstore**. Eso significa que no existe. El Boot Manager la busca, no la encuentra, la descarta silenciosamente, y cae al siguiente en la lista: `Boot0001` = EFI Internal Shell.


**El flujo completo**:

```
Firmware arranca
       ↓
Lee BootOrder → [0x0000, 0x0001]
       ↓
Busca Boot0000 → no existe → descarta
       ↓
Busca Boot0001 → existe, ACTIVE=1
       ↓
Resuelve Device Path → EFI Internal Shell interna
       ↓
Carga y ejecuta → aparece el prompt Shell>
```

