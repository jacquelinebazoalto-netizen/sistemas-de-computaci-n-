# Laboratorio N° 3: "Modo Real vs. Modo Protegido"

## UEFI y Coreboot

### ¿Qué es UEFI? ¿como puedo usarlo? Mencionar además una función a la que podría llamar usando esa dinámica.
UEFI (Unified Extensible Firmware Interface) es una interfaz de firmware estándar que reemplaza al BIOS tradicional.
Es el software que arranca la computadora antes del sistema operativo
Define cómo interactúan: el hardware,el firmware y el sistema operativo
### ¿Cómo podés usarlo?
A través de:
Aplicaciones UEFI
Drivers UEFI
Bootloaders
Todos estos interactúan usando:
Boot Services
Runtime Services
La dinámica de uso de UEFI consiste en acceder a la UEFI System Table, que es la estructura principal desde donde el firmware expone sus servicios. A partir de esta tabla, se obtienen punteros a distintas funciones organizadas en Boot Services y Runtime Services. Utilizando estos punteros, el programa puede invocar funciones del firmware para realizar diversas tareas, como manejar memoria, cargar aplicaciones o interactuar con dispositivos, todo dentro del entorno previo al sistema operativo.
Un ejemplo de función importante dentro del entorno UEFI es LoadImage(). Esta función se utiliza para cargar en memoria una imagen ejecutable UEFI, como puede ser un bootloader o una aplicación. Su uso permite preparar el programa para su posterior ejecución, facilitando así el proceso de arranque del sistema o la ejecución de herramientas en la etapa previa al sistema operativo.



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
---
<- BORRAR Y RESPONDER ACÁ->


## Linker

### ¿Que es un linker? ¿que hace?
---
<- BORRAR Y RESPONDER ACÁ->


### ¿Que es la dirección que aparece en el script del linker?¿Porqué es necesaria?
---
<- BORRAR Y RESPONDER ACÁ->

### Compare la salida de objdump con hd, verifique donde fue colocado el programa dentro de la imagen.
---
<- BORRAR Y RESPONDER ACÁ->

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

