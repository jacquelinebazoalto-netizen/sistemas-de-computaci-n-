# Laboratorio N° 3.a: Entorno UEFI, Desarrollo y Análisis de Seguridad

## Trabajo Práctico 1: Exploración del entorno UEFI y la Shell

### ¿Cuál es la ventaja de seguridad y compatibilidad de este modelo frente al antiguo BIOS?

El modelo de handles y protocolos de UEFI presenta ventajas significativas en términos de compatibilidad y seguridad frente al enfoque tradicional del BIOS.

Desde el punto de vista de la compatibilidad, este modelo permite que distintos dispositivos de hardware implementen una misma interfaz estándar a través de protocolos. Esto implica que el software no necesita conocer detalles específicos del hardware, ya que interactúa con él mediante una capa de abstracción. Como resultado, la incorporación de nuevas tecnologías no requiere modificar el software existente, lo que facilita la evolución del sistema.

En cuanto a la seguridad, el modelo evita el acceso directo al hardware, eliminando la posibilidad de que aplicaciones interactúen con puertos de entrada/salida o direcciones de memoria de forma arbitraria. En su lugar, toda interacción se realiza a través de interfaces controladas por el firmware, lo que reduce la superficie de ataque y permite un mayor control sobre las operaciones realizadas.

En conjunto, este enfoque mejora la robustez del sistema, facilita su mantenimiento y permite implementar mecanismos de seguridad más efectivos en etapas tempranas del arranque.

### Observando las variables Boot#### y BootOrder, ¿cómo determina el Boot Manager la secuencia de arranque?

El Boot Manager de UEFI determina la secuencia de arranque a partir de variables almacenadas en memoria no volátil (NVRAM), principalmente `BootOrder` y `Boot####`. La variable `BootOrder` contiene una lista ordenada de identificadores que establecen la prioridad de las distintas opciones de arranque disponibles en el sistema.

Para cada identificador presente en `BootOrder`, el firmware accede a la variable `Boot####` correspondiente, la cual almacena la información necesaria para localizar un archivo ejecutable en formato `.efi`, incluyendo su *device path*. A partir de esta información, el firmware utiliza el modelo de handles y protocolos para resolver la ubicación del archivo dentro del sistema.

Si el archivo indicado existe y cumple con las políticas de seguridad establecidas, como la verificación de firma en caso de que Secure Boot esté habilitado, el Boot Manager procede a cargarlo en memoria y transferirle el control. La entrada utilizada en el arranque queda registrada en la variable `BootCurrent`, lo que permite identificar qué opción fue efectivamente ejecutada.

En caso de que alguna entrada falle, ya sea porque el archivo no se encuentra o no supera las validaciones correspondientes, el sistema continúa con la siguiente opción definida en `BootOrder`. De esta manera, UEFI implementa un mecanismo de arranque flexible, configurable y más robusto que el modelo tradicional basado en BIOS.

### En el mapa de memoria (memmap), existen regiones marcadas como RuntimeServicesCode. ¿Por qué estas áreas son un objetivo principal para los desarrolladores de malware (Bootkits)?

Las regiones de tipo `RuntimeServicesCode` son especialmente sensibles desde el punto de vista de seguridad, ya que contienen funciones del firmware que continúan disponibles una vez iniciado el sistema operativo. Si un atacante logra modificar estas áreas, puede ejecutar código con privilegios elevados durante el funcionamiento normal del sistema. A esto se suma que, al pertenecer al entorno del firmware, su análisis no es habitual para las herramientas de protección tradicionales, lo que incrementa la dificultad para detectar y eliminar este tipo de amenazas.

## Trabajo Práctico 2: Desarrollo, compilación y análisis de seguridad

### ¿Por qué utilizamos SystemTable->ConOut->OutputString en lugar de la función printf de C?

Se utiliza `SystemTable->ConOut->OutputString` en lugar de `printf` porque el entorno UEFI no cuenta con un sistema operativo ni con librerías estándar como la libc. No existen funciones como `printf`, ya que estas dependen de servicios del sistema operativo que no están disponibles en una etapa previa al arranque. Por lo tanto, la única forma de realizar salida por pantalla es mediante los servicios que provee el firmware, accediendo a ellos a través de la estructura `EFI_SYSTEM_TABLE`. La función `OutputString` pertenece al protocolo de salida de texto de UEFI y permite imprimir mensajes en consola utilizando directamente las capacidades del firmware.

###  En el pseudocódigo de Ghidra, la condición 0xCC suele aparecer como -52. ¿A qué se debe este fenómeno y por qué importa en ciberseguridad?

El valor `0xCC` puede aparecer como `-52` en el pseudocódigo de Ghidra debido a la interpretación del dato como un entero con signo de 8 bits (*signed char*). En representación en complemento a dos pero se interpreta como `-52` cuando se considera con signo. Este fenómeno es relevante en ciberseguridad porque `0xCC` corresponde a la instrucción `INT3`, utilizada como breakpoint en depuración. Si un analista no reconoce esta conversión, podría pasar por alto la presencia de instrucciones relacionadas con debugging o técnicas de evasión, lo que puede afectar la correcta interpretación del comportamiento del código analizado.

## Trabajo Práctico 3: Ejecución en Hardware Físico (Bare Metal)