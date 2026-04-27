# Laboratorio N° 3: "Modo Real vs. Modo Protegido"

## UEFI y Coreboot

### ¿Qué es UEFI? ¿como puedo usarlo? Mencionar además una función a la que podría llamar usando esa dinámica.
---
UEFI (Unified Extensible Firmware Interface) es una especificación de firmware moderna que reemplaza al BIOS tradicional. Actúa como una capa intermedia entre el hardware y el sistema operativo, encargándose de la inicialización del sistema y del proceso de arranque.

A diferencia del BIOS, UEFI posee una arquitectura modular, soporte para discos grandes (GPT), interfaz gráfica y capacidades de seguridad avanzadas.

Se puede utilizar accediendo al menú de firmware durante el arranque del sistema (teclas como F2, DEL o ESC). Desde allí es posible:
- Configurar el orden de booteo
- Habilitar o deshabilitar dispositivos
- Gestionar opciones de seguridad
- Configurar parámetros de hardware

Una función importante accesible mediante esta interfaz es Secure Boot, que permite verificar criptográficamente la integridad del sistema operativo antes de su ejecución, evitando la carga de software no autorizado o malicioso.

### Casos de bugs de UEFFI que puedes ser explotados
---
Existen múltiples vulnerabilidades en UEFI que han sido explotadas. Un caso relevante es el de equipos Lenovo con fallas como:

CVE-2021-3971 y CVE-2021-3972: permiten modificar variables NVRAM y desactivar protecciones como Secure Boot.
CVE-2021-3970: permite ejecución de código con privilegios elevados.

Estos bugs permiten instalar bootkits, malware que se ejecuta antes del sistema operativo, como:

- MosaicRegressor
- Lojax

Este tipo de ataques es particularmente peligroso porque:

- Se ejecuta antes del sistema operativo
- Puede persistir incluso después de reinstalar el sistema
- Es difícil de detectar con herramientas tradicionales

### ¿Qué es Converged Security and Management Engine (CSME), the Intel Management Engine BIOS Extension (Intel MEBx).?
---
Intel CSME es un subsistema embebido dentro del chipset que funciona de manera independiente del CPU principal. Se encarga de:

- Seguridad (Boot Guard, TPM, DRM)
- Inicialización del hardware
- Gestión remota (Intel AMT)

Opera incluso cuando el sistema está apagado.

Por otro lado, Intel MEBx (Management Engine BIOS Extension) es la interfaz de configuración integrada en el BIOS/UEFI que permite al usuario configurar el comportamiento del Management Engine, incluyendo parámetros de red, seguridad y administración remota.

### ¿Qué es coreboot ? ¿Qué productos lo incorporan ?¿Cuales son las ventajas de su utilización?
---
El coreboot es un firmware de código abierto que reemplaza BIOS/UEFI. Su objetivo es realizar únicamente la inicialización mínima del hardware y luego transferir el control a un payload (por ejemplo, un bootloader o directamente un sistema operativo).

Productos que lo usan:

- Chromebooks
- Servidores (ej: centros de datos)
- Sistemas embebidos

Ventajas:

- Código abierto → mayor auditabilidad y transparencia
- Menor tamaño → reducción de la superficie de ataque
- Arranque significativamente más rápido
- Alta flexibilidad mediante payloads personalizados
- Diseño minimalista que mejora la seguridad (menor complejidad)


### Hello World: Compilar y Linkear
---
<- BORRAR Y RESPONDER ACÁ->


## Linker

### ¿Que es un linker? ¿que hace?
---
El linker (enlazador) es una herramienta fundamental en el proceso de compilación que combina múltiples archivos objeto en un único archivo ejecutable.
Sus funciones principales son:

- Une archivos objeto en un ejecutable
- Resuelve símbolos (funciones/variables)
- Reubica direcciones en memoria
- Organiza secciones (.text, .data)


### ¿Que es la dirección que aparece en el script del linker?¿Porqué es necesaria?
---
Es la dirección de memoria donde se ubicará el programa al ejecutarse. Es necesaria porque la BIOS carga el bootloader en esa dirección. El linker debe saberlo para calcular correctamente saltos y accesos a memoria.
Es necesaria porque:

- La BIOS carga el bootloader en una dirección fija (0x7C00)
- El código debe coincidir con esa ubicación para que los saltos y referencias sean correctos

Sin esta información, el programa no funcionaría correctamente debido a errores en direccionamiento.

### Compare la salida de objdump con hd, verifique donde fue colocado el programa dentro de la imagen.
---
<- BORRAR Y RESPONDER ACÁ->

### ¿Para que se utiliza la opción --oformat binary en el linker?
---
Se usa para generar un binario puro, sin encabezados.

Sirve para:

Bootloaders
Sistemas embebidos
Carga directa en memoria

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
Se cargan con selectores de segmento, no direcciones reales.

Estos selectores apuntan a entradas de la GDT o LDT y contienen:

- Índice
- Tipo de tabla (GDT/LDT)
- Nivel de privilegio

Se usan porque:

- Permiten abstracción de memoria
- Mejoran la seguridad
- Habilitan multitarea y protección

## Conclusión

El trabajo muestra cómo funciona el sistema desde el arranque a muy bajo nivel:

UEFI y BIOS controlan el inicio del sistema
El linker permite construir ejecutables correctamente ubicados en memoria
El modo protegido introduce seguridad y control de memoria mediante segmentación
coreboot y tecnologías como CSME muestran la evolución del firmware moderno

En conjunto, se entiende cómo el hardware, firmware y software interactúan desde el primer ciclo de ejecución hasta el sistema operativo.
