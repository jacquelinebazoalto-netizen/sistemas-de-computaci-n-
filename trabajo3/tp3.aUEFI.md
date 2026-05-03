## Interfaz de Firmware Extensible Unificada (UEFI) 

La Interfaz de Firmware Extensible Unificada (UEFI) es la infraestructura de firmware estándar de la industria diseñada para reemplazar al tradicional Legacy BIOS 1. A diferencia de las limitaciones históricas del BIOS —que dependía de hardware heredado (como el timer 8254 o el controlador de interrupciones 8259), operaba en modo de 16 bits y tenía un límite estricto de 1MB de memoria— UEFI ofrece una arquitectura moderna, modular y compatible con procesadores de 32 bits, 64 bits (x64, ARM, Itanium) 2, 1, 3.
Es fundamental distinguir entre dos conceptos arquitectónicos que trabajan en conjunto 4, 5:
UEFI: Es puramente una especificación de interfaz. Define las APIs, estructuras de datos y el entorno pre-sistema operativo (pre-OS) mediante el cual interactúan el firmware, los componentes de hardware y los cargadores del sistema operativo (OS loaders) 4, 6.
PI (Platform Initialization): Es la arquitectura interna del firmware. Define cómo se construye la plataforma desde el momento del restablecimiento (reset) del hardware, estableciendo fases de control bien definidas hasta que se crea el entorno UEFI para el OS 5.

## Entorno UEFI, Desarrollo y Análisis de Seguridad

Objetivo General: Comprender la arquitectura de la Interfaz de Firmware Extensible Unificada (UEFI) como un entorno pre-sistema operativo, desarrollar binarios nativos, entender su formato y ejecutar rutinas tanto en entornos emulados como en hardware físico (bare metal).

##  Exploración del entorno UEFI y la Shell
 Explorar cómo UEFI abstrae el hardware y gestiona la configuración antes de la carga del sistema operativo.

## 1.1 Arranque en el entorno virtual
Comando:
## Exploración de Dispositivos (Handles y Protocolos):


##  Al ejecutar el comando map y dh, vemos protocolos e identificadores en lugar de puertos de hardware fijos.
## ¿Cuál es la ventaja de seguridad y compatibilidad de este modelo frente al antiguo BIOS?
El modelo de UEFI basado en handles y protocolos ofrece una ventaja significativa frente al BIOS tradicional, ya que introduce una capa de abstracción sobre el hardware. En lugar de acceder directamente a direcciones físicas o puertos específicos, el sistema interactúa mediante interfaces estandarizadas. Esto mejora la compatibilidad, ya que un mismo código puede ejecutarse en distintos dispositivos sin modificaciones, y también incrementa la seguridad, al evitar accesos directos al hardware que podrían ser explotados por software malicioso. Además, este enfoque favorece la modularidad y la extensibilidad del sistema

## Análisis de Variables Globales (NVRAM)
## Observando las variables Boot#### y BootOrder, ¿cómo determina el Boot Manager la secuencia de arranque?
El Boot Manager de UEFI determina la secuencia de arranque utilizando variables almacenadas en memoria no volátil (NVRAM), principalmente Boot#### y BootOrder. Cada variable Boot#### representa una opción de arranque específica, como un disco o dispositivo USB, mientras que BootOrder define el orden en que estas opciones deben intentarse. Durante el proceso de arranque, el sistema recorre la lista indicada en BootOrder y prueba cada entrada en ese orden hasta encontrar una opción válida que permita iniciar el sistema.

## Footprinting de Memoria y Hardware
## En el mapa de memoria (memmap), existen regiones marcadas como RuntimeServicesCode. 
## ¿Por qué estas áreas son un objetivo principal para los desarrolladores de malware (Bootkits)?
Las regiones de memoria marcadas como RuntimeServicesCode son un objetivo principal para malware como los bootkits debido a que permanecen accesibles incluso después de que el sistema operativo ha iniciado. Esto permite que código malicioso alojado en estas áreas mantenga su ejecución con altos privilegios, logrando persistencia a bajo nivel. Además, al formar parte del entorno de firmware, estas regiones son más difíciles de inspeccionar y detectar por herramientas de seguridad tradicionales, lo que las convierte en un vector especialmente peligroso.


## Trabajo Práctico 2: Desarrollo, compilación y análisis de seguridad
Crear una aplicación nativa UEFI en C, entender el formato PE/COFF y analizar cómo un descompilador interpreta opcodes a nivel de firmware.

## ¿Por qué utilizamos SystemTable->ConOut->OutputString en lugar de la función printf de C?
Se utiliza la función SystemTable->ConOut->OutputString en lugar de printf porque en el entorno UEFI no existe un sistema operativo ni las bibliotecas estándar del lenguaje C, como la libc. La función printf depende de estas bibliotecas, por lo que no está disponible en este contexto. En su lugar, UEFI proporciona sus propias interfaces para entrada y salida, siendo OutputString el método adecuado para mostrar texto en pantalla dentro de este entorno de firmware.

## Análisis de Metadatos y Decompilación

## En el pseudocódigo de Ghidra, la condición 0xCC suele aparecer como -52. ¿A qué se debe este fenómeno y por qué importa en ciberseguridad?
El valor 0xCC aparece como -52 en el pseudocódigo de Ghidra debido a la interpretación del dato como un entero con signo de 8 bits (signed char). En hexadecimal, 0xCC equivale a 204 en decimal sin signo, pero al interpretarse con signo mediante complemento a dos, se representa como -52. Este fenómeno es relevante en ciberseguridad, ya que la interpretación de los datos puede variar según el contexto, lo que puede ser utilizado para ocultar instrucciones o comportamientos maliciosos. Comprender estas diferencias es fundamental para el análisis correcto de binarios y la detección de código potencialmente dañino.

## Trabajo Práctico 3: Ejecución en Hardware Físico (Bare Metal)
Trasladar el binario compilado a una computadora real (ej. Lenovo T450) sorteando las restricciones del Secure Boot
