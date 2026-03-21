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
- **Compilación de código GCC**.
- **FPS en juegos**.
- **Handbreak**: El encoder de HandBreak viene con varias opciones para que se pueda usar fácilmente el benchmark para CPU que se necesite. Mide el tiempo necesario para codificar un video y luego usas eso como tu baseline de comparación.

