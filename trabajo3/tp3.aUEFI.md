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

## Análisis de Variables Globales (NVRAM)
## Observando las variables Boot#### y BootOrder, ¿cómo determina el Boot Manager la secuencia de arranque?

## Footprinting de Memoria y Hardware
## En el mapa de memoria (memmap), existen regiones marcadas como RuntimeServicesCode. 
## ¿Por qué estas áreas son un objetivo principal para los desarrolladores de malware (Bootkits)?
