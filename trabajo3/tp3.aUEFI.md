# Laboratorio N° 3.a: Entorno UEFI, Desarrollo y Análisis de Seguridad

## Trabajo Práctico 1: Exploración del entorno UEFI y la Shell

### ¿Cuál es la ventaja de seguridad y compatibilidad de este modelo frente al antiguo BIOS?

El modelo de handles y protocolos de UEFI presenta ventajas significativas en términos de compatibilidad y seguridad frente al enfoque tradicional del BIOS.

Desde el punto de vista de la compatibilidad, este modelo permite que distintos dispositivos de hardware implementen una misma interfaz estándar a través de protocolos. Esto implica que el software no necesita conocer detalles específicos del hardware, ya que interactúa con él mediante una capa de abstracción. Como resultado, la incorporación de nuevas tecnologías no requiere modificar el software existente, lo que facilita la evolución del sistema.

En cuanto a la seguridad, el modelo evita el acceso directo al hardware, eliminando la posibilidad de que aplicaciones interactúen con puertos de entrada/salida o direcciones de memoria de forma arbitraria. En su lugar, toda interacción se realiza a través de interfaces controladas por el firmware, lo que reduce la superficie de ataque y permite un mayor control sobre las operaciones realizadas.

En conjunto, este enfoque mejora la robustez del sistema, facilita su mantenimiento y permite implementar mecanismos de seguridad más efectivos en etapas tempranas del arranque.

### Observando las variables Boot#### y BootOrder, ¿cómo determina el Boot Manager la secuencia de arranque?

### En el mapa de memoria (memmap), existen regiones marcadas como RuntimeServicesCode. ¿Por qué estas áreas son un objetivo principal para los desarrolladores de malware (Bootkits)?

## Trabajo Práctico 2: Desarrollo, compilación y análisis de seguridad

### ¿Por qué utilizamos SystemTable->ConOut->OutputString en lugar de la función printf de C?

### Pregunta de Razonamiento 5: En el pseudocódigo de Ghidra, la condición 0xCC suele aparecer como -52. ¿A qué se debe este fenómeno y por qué importa en ciberseguridad?

## Trabajo Práctico 3: Ejecución en Hardware Físico (Bare Metal)