## Tipos de _benchmarks_

### Sintéticos
---
Programas diseñados específicamente para medir rendimiento. Ejecutan cargas artificiales controladas y buscan aislas componentes (CPU, GPU, RAM).
Ejemplos:
- **Cinebench R23**: Este es uno de los benchmarks más usados para los CPU.
- **UL Benchmarks 3DMark**: Este benchmark sintético de CPU tiene un montón de test incluidos para CPUs y GPUs.
- **CrystalDiskMark**: Aplicación de software gratuita para Windows utilizada para evaluar el rendimiento de unidades de almacenamiento
- **CPU Z**: Este programa muestra detalles del procesador, pero también tiene un benchmark de CPU que es muy facil de ejecutar.
- **C-Ray**: Este benchmark de CPU usa un motor de renderizado _raytracing_ para medir la performance en operaciones de punto flotante.
- **WebXPRT 4**: Este es un benckmark _click-to-run_ de CPU que se ejecuta en el navegador para medir la performace de HTML5, JavaScript y tests WebAssembly-based.
- **ARES-6**: Este es un _click-to-run_ CPU benchmark que también se ejecuta en el navegador para medir la performance en JavaScript, pero tiene un fuerte enfoque en las neural network (machine learning) workloads.

### Reducidos
---
Evalúan una parte representativa de una aplicación real, pero no la aplicación completa. Son una simplificación de un workload real.
Ejemplo:
- **POV-Ray**: Este benchmark de renderizado de CPU tiene opciones de testeo para single y multi-thread.
- **Render en Blender**: Software libre y de código abierto para la creación de contenido 3D.
- **Corona**: Este es otro popular de renderización, utiliza el motor de renderizado Chaos Corona para medir la performance del CPU en cargas de trabajo multi-hilo.

### Kernel
---
Miden el rendimiento de operaciones muy específicas y fundamentales: operaciones matemáticas, acceso a memoria, loops críticos.
Ejemplos:
- **y-cruncher**: Este es un benchmark de CPU que se ejecuta en la línea de comandos.

### Programas Reales
---
Aplicaciones reales usadas tal cual en producción. Se mide el tiempo o rendimiento en tareas reales.
Ejemplos:
- **Compilación de código GCC**: Se puede medir cuánto tarda en completar una tarea real y comparar ese tiempo entre sistemas.
- **FPS en juegos**.
- **Handbreak**: El encoder de HandBreak viene con varias opciones para que se pueda usar fácilmente el benchmark para CPU que se necesite. Mide el tiempo necesario para codificar un video y luego usas eso como tu baseline de comparación.

## Benchmark que podríamos utilizar en nuestro día a día según las tareas que realizamos en nuestra PC:

| Actividad                           |Benchmark           |
| -------------------------------------------------- | ---------------------------------- |
| Compilar código C/C++          | Compilación con GCC                |
| Usar IDEs (JetBrains, VS Code) + multitarea        | Cinebench R23 (multi-core)         |
| Procesamiento intensivo de CPU                     | HandBrake                          |
| Renderizado / cargas paralelas                     | Corona Renderer                    |
| Uso de terminal y scripts                | y-cruncher                         |
| Uso del navegador (muchas pestañas, apps web)      | WebXPRT 4                          |
| Lectura/escritura de archivos (proyectos, SO)      | CrystalDiskMark                    |
| Gaming en Windows                                  | FPS en juegos  |
| Evaluar GPU + CPU en juegos                        | 3DMark                             |
| Verificar estabilidad del sistema                  | y-cruncher                         |
| Evaluar rendimiento general del CPU       | CPU-Z                              |


## Comparación compilación del Kernel de Linux con los procesadores Intel Core i5-13600K y AMD Ryzen 9 5900X 12 Core

Para realizar esta comparación utilizamos la página [Open Benchmarking](https://openbenchmarking.org/test/pts/build-linux-kernel&eval=cb81925dba817594f846f03a3bc29a81ef048649#metrics). En específico se hará la comparación para la compilación de la versión 1.16.x del Kernel de Linux, con la *build* `allmodconfig`, esto quiere decir que se compila el kernel junto con casi todos sus drivers, por lo tanto es mucho más tiempo de compilación que si se tratara de la build `defconfig`. Hace mucho más uso del CPU estresando el sistema.

### AMD Ryzen 9 5900X 12 Core
![AMD Ryzen 9 5900X 12 Core Benchmark](/trabajo1/imagenes/amd-ryzen-9-5900x.jpeg)
La última columna indica el tiempo de compilación promedio: **1309 +/- 37 segundos**.

vs.

### Intel Core i5-13600K
![Intel Core i5-13600K](/trabajo1/imagenes/intel-i5-13600k.jpeg)
La última columna indica **1094 segundos**.

Por lo tanto el procesaor Intel Core i5-13600K es más eficiente porque tarda menos tiempo en compilar el Kernel de Linux.




## GNU GCC Profiling
Las herramientas para analizar el tiempo de ejecución del programa/uso de memoria se llaman generadores de perfiles.Los generadores de perfiles de código a menudo se usan para analizar no solo cuánto tiempo tarda en ejecutarse un programa (podemos obtenerlo de herramientas a nivel de shell como /usr/bin/time), sino también cuánto tiempo tarda en ejecutarse cada función o método (tiempo de CPU). Dos técnicas principales utilizadas por los perfiladores: inyección de código, muestreo.


