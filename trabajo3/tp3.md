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
### Funcion Ejemplo:
Un ejemplo de función importante dentro del entorno UEFI es LoadImage(). Esta función se utiliza para cargar en memoria una imagen ejecutable UEFI, como puede ser un bootloader o una aplicación. Su uso permite preparar el programa para su posterior ejecución, facilitando así el proceso de arranque del sistema o la ejecución de herramientas en la etapa previa al sistema operativo.



### Casos de bugs de UEFFI que puedes ser explotados
Un caso de vulnerabilidad en UEFI mencionado en el documento es el S3 Resume Boot Script Attack. Este ocurre durante la reanudación del sistema desde el estado de suspensión (S3), donde el firmware utiliza un “boot script” previamente generado para reconfigurar rápidamente el hardware. Si este script no está adecuadamente protegido, un atacante puede modificarlo o alterar sus punteros, logrando así la ejecución de código arbitrario en una etapa muy temprana del arranque, comprometiendo la seguridad del sistema.

Además, existen otros posibles bugs en UEFI, como el Secure Boot Bypass, que ocurre cuando fallas en la verificación de firmas digitales permiten ejecutar software no autorizado, y los ataques a drivers UEFI, donde controladores maliciosos pueden cargarse si no se implementan correctamente los mecanismos de validación. Estas vulnerabilidades son críticas debido a que afectan una capa fundamental del sistema, permitiendo incluso persistencia a nivel de firmware.


### ¿Qué es Converged Security and Management Engine (CSME), the Intel Management Engine BIOS Extension (Intel MEBx).?

El Converged Security and Management Engine (CSME) es un subsistema integrado en los chipsets de Intel que funciona como un microcontrolador independiente dentro de la plataforma. Opera de manera separada del procesador principal y del sistema operativo, y se encarga de funciones relacionadas con la seguridad, la gestión remota y el arranque del sistema. Entre sus tareas se incluyen la verificación de integridad del firmware, la ejecución de funciones criptográficas y el soporte de tecnologías como Intel Active Management Technology (AMT), permitiendo administrar equipos incluso cuando están apagados o sin sistema operativo activo.

Por otro lado, el Intel Management Engine BIOS Extension (Intel MEBx) es una interfaz de configuración accesible desde el BIOS/UEFI que permite al usuario o administrador configurar las funcionalidades del Management Engine. A través de MEBx se pueden establecer parámetros como la configuración de red, credenciales de acceso y opciones de administración remota. En conjunto, CSME y MEBx forman parte de la infraestructura de gestión y seguridad de las plataformas Intel, operando a un nivel muy bajo dentro del sistema.


### ¿Qué es coreboot ? ¿Qué productos lo incorporan ?¿Cuales son las ventajas de su utilización?
Coreboot es un proyecto de firmware de código abierto que reemplaza al BIOS o UEFI tradicional en una computadora. Su función principal es inicializar el hardware del sistema de la manera más rápida y simple posible, para luego transferir el control a un programa de arranque más completo, como un bootloader o incluso directamente a un sistema operativo. A diferencia de las soluciones propietarias, coreboot permite acceso y modificación de su código, lo que lo hace altamente flexible y adaptable.
### Productos que lo incorporan
Este firmware es utilizado en diversos productos, especialmente en dispositivos que priorizan seguridad, transparencia o personalización. Por ejemplo, es empleado en algunas computadoras portátiles de fabricantes como Google (Chromebooks), en servidores, sistemas embebidos y equipos especializados donde se requiere control total del firmware.
### Ventajas de utilización
Entre las principales ventajas de coreboot se encuentran su rapidez de arranque, ya que inicializa solo el hardware necesario; su carácter de código abierto, que permite auditorías de seguridad y modificaciones; y su flexibilidad, al poder adaptarse a distintas plataformas y necesidades específicas. Además, reduce la dependencia de firmware propietario, lo cual es importante en entornos donde la seguridad y la confianza en el sistema son críticas.


### Hello World: Compilar y Linkear



## Linker

### ¿Que es un linker? ¿que hace?
Un linker es una herramienta que combina uno o más archivos objeto (.o) generados por el compilador en un solo archivo ejecutable o binario. Resuelve referencias a funciones o variables entre los distintos archivos.
¿Qué hace el Linker?

_Asigna direcciones de memoria a las instrucciones y datos.
_Resuelve direcciones de etiquetas.
_Agrupa las diferentes secciones (.text, .data, .bss) de manera coherente.


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

