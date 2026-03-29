## Tipos de _benchmarks_

Los benchmarks pueden clasificarse según el componente que evalúan (CPU, GPU, memoria, almacenamiento), el tipo de prueba (sintéticos o del mundo real), y el objetivo (rendimiento, estrés o consumo).

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

Los benchmarks más útiles son aquellos que representan de forma más realista las tareas que cada usuario realiza diariamente.

En este caso, los benchmarks más útiles son:

- 3DMark, para evaluar el rendimiento en videojuegos y tareas gráficas.
- HandBrake, para medir el rendimiento en procesamiento de video.
- Cinebench R23, para evaluar el rendimiento general del procesador.
- y-cruncher y C-Ray, para medir cálculos intensivos como los utilizados en simulaciones.
- WebXPRT 4, para evaluar el rendimiento en aplicaciones web.

Estos benchmarks permiten obtener una visión completa del rendimiento del sistema en distintos escenarios.


## Benchmark que podríamos utilizar en nuestro día a día según las tareas que realizamos en nuestra PC:


*Benchmark utilizados por la integrante Rocabado Bazoalto Jacqueline*
| Tarea                              | Benchmark Más Representativo | Motivo                                                                 |
|-----------------------------------|-----------------------------|------------------------------------------------------------------------|
| Simulación de circuitos (Multisim) | Whetstone                   | Evalúa cálculos de punto flotante, clave en simulaciones eléctricas   |
| Edición de documentos y PDFs       | SPEC CPU                    | Mide el rendimiento en cargas de trabajo generales                    |
| Navegación web y multitarea        | Imbench                     | Mide latencias de memoria y eficiencia del sistema operativo          |
| Programación y compilación (C, Python) | SPEC CPU / Dhrystone       | Evalúan rendimiento en operaciones con enteros y ejecución de código  |
| Cálculos en Excel y MATLAB         | LINPACK / STREAM            | Miden capacidad de procesamiento matemático y ancho de banda de memoria |


*Benchmarks utilizados por el integrante Brezzo Benjamin*
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


*Benchmarks utilizados por el integrante Cruz Enrique Luis Fernando*
| Tarea | Benchmark |
|------|----------|
| Ver videos | HandBrake |
| Videojuegos | UL Brenchmarks 3DMark |
| Simulación de circuitos (Multisim, SPICE) | C-Ray |
| Uso general de la PC | CPU-Z |
| Navegación web | ARES-6 |



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



### Aceleración cuando usamos un AMD Ryzen 9 7950X 16-Core respecto al Intel Core i5-13600K

Aceleracion = $\frac{Rendimiento Mejorado}{Rendimiento Original}$ = $\frac{EXcpu_original}{EXcpu_mejorado}$ = $\frac{1094Seg}{630Seg}$ = 1.73

Intel Core i5-13600K

Eficiencia  = $\frac{1.73}{14 Nucleos}$ = 0.123

AMD Ryzen 9 5900HX 16-Core

Eficiencia  = $\frac{1.73}{16 Nucleos}$ = 0.108

Aceleración cuando usamos un AMD Ryzen 9 7950X 16-Core respecto al AMD Ryzen 9 5900X 12-Core

Aceleracion = $\frac{Rendimiento Mejorado}{Rendimiento Original}$ = $\frac{EXcpu_original}{EXcpu_mejorado}$ = $\frac{1309Seg}{630Seg}$ = 2.07

AMD Ryzen 9 5900HX 12-Core

Eficiencia  = $\frac{2.07}{12 Nucleos}$ = 0.172

AMD Ryzen 9 5900HX 16-Core

Eficiencia  = $\frac{2.07}{16 Nucleos}$ = 0.129

En el análisis realizado, el AMD Ryzen 9 7950X presenta la mayor aceleración, alcanzando mejoras de hasta aproximadamente 2.07 veces respecto al Ryzen 9 5900X y 1.73 frente al Intel Core i5-13600K.

El procesador que hace un uso más eficiente de la cantidad de núcleos es el Intel Core i5-13600K, ya que obtiene un rendimiento elevado con una menor cantidad de núcleos, lo que demuestra un mejor aprovechamiento de cada uno en comparación con el Ryzen 9 7950X.

Precios de los procesadores: 

Ryzen 301,97 dolares

Intel 428 dolares

Ryzen 7950 802 dolares 

En términos de costo, el AMD Ryzen 9 5900HX 12-Core que ofrece un buen rendimiento a un precio más accesible. Además, también presenta un consumo energético menor que el Ryzen 9 7950X, lo que lo hace más conveniente en relación rendimiento/consumo. Por otro lado, aunque el Ryzen 9 7950X es el más potente, su mayor costo y consumo lo hacen menos eficiente en este aspecto.



## GNU GCC Profiling
Las herramientas para analizar el tiempo de ejecución del programa/uso de memoria se llaman generadores de perfiles.Los generadores de perfiles de código a menudo se usan para analizar no solo cuánto tiempo tarda en ejecutarse un programa (podemos obtenerlo de herramientas a nivel de shell como /usr/bin/time), sino también cuánto tiempo tarda en ejecutarse cada función o método (tiempo de CPU). Dos técnicas principales utilizadas por los perfiladores: inyección de código, muestreo.

Vamos a utilizar la herramienta `gprof` para analizar el tiempo de ejecución. Para esto necesitamos:
- Habilitar "profiling" durante la compilación
- Ejecutar el código del programa para producir los datos de perfil
- Ejecutar la herramienta gprof en el archivo de datos de generación de perfiles generado en el paso anterior

Este último paso genera un archivo de análisis legible por humanos. Este archivo contiene un **perfil plano** y **gráfico de llamadas**. 
- El perfil plano brinda una descripción general de la información de tiempo de las funciones, como el consumo de tiempo para la ejecución de una función en particular, cuántas veces se llamó. etc.
- El gráfico de llamadas se enfoca en cada función como las funciones a través de las cuales un determinado se llamó a la función, qué funciones se llamaron desde dentro de esta función en particular, etc. De esta manera, también se puede tener una idea del tiempo de ejecución empleado en las subrutinas.

Los códigos de [test_gprof.c](/trabajo1/profiling/test_gprof.c) y [test_gprof_new.c](/trabajo1/profiling/test_gprof_new.c) se utilizarán para producir los datos de perfil.

**Desarrollo**:
![desarrollo-profiling](/trabajo1/imagenes/Captura%20desde%202026-03-21%2019-08-38.png)

*Ejecución de la herramienta gprof*:
![ejecución-gprof](/trabajo1/imagenes/Captura%20desde%202026-03-21%2019-34-54.png)

**Resultados**:
![resultados-gprof](/trabajo1/imagenes/Captura%20desde%202026-03-21%2019-46-23.png)

*Interpretación*:

- El archivo .txt nos dice inicialmente que la base de tiempos es de 0.01 [s].
- En la primera columna se especifica el porcentaje que representa cada función del programa total:
  -  La función `func1` es el 55,41% del programa.
  -  La función `func2` es el 37,73% del programa.
  -  Mientras que `new_func1` y `main` son un 3,43% del programa cada una, o 6,87% en conjunto.
-  En la segunda columna se expresa el tiempo acumulado por cada función. **Se tiene un tiempo total de 13,12 [s]**.
-  En la tercera columna podemos ver el tiempo individual de cada función.
-  La cuarta y quinta columna expresan el tiempo promedio de ejecución por llamada a la función y el tiempo sobre el total de llamadas a funciones.

Interpretación del **call graph** (*gráfico de llamadas*):
![call-graph](/trabajo1/imagenes/Captura%20desde%202026-03-21%2019-59-34.png)

> La "*granularity*" es el nivel de detalle con que se registran y analizan las llamadas a funciones y el tiempo de ejecución de cada función en un programa durante el profiling.

Esta tabla describe el árbol de llamadas del programa y fue ordenada por la cantidad total de tiempo empleado en cada función y sus hijos.

- La columna de `index` enumera a la función actual. Las líneas que se encuentren por arriba enumeran las funciones que llamaron a esta funcón, y las líneas debajo enumeran las funciones a las que llama.
- La columna `time` es el porcentaje de tiempo total que se dedicó en la función y sus hijos:
  - La función `main` tomó el 100% del tiempo de ejecución en ejecutarse ella misma y llamar a `func1` y `func2`.
  - La función `func1` tomó un 58,8% del tiempo de ejecución en ejecutarse ella misma y llamar a la función `new_func1`.
  - La función `func2` tomó un 37,2% del tiempo de ejecución en ejecutarse.
  - La función `new_func1` tom+o un 3,4% del tiempo de ejecución en ejecutarse.
- La columna `self` es la cantidad total de tiempo empleado en cada función.
- La columna `children` indica la cantidad de tiempo propagado en esta función por sus hijos.
- La columna `called` es el número de veces que se llamó a la función.

### Utilizando gprof con flags
- Usando la flag `-a` podemos evitar la impresión de las funciones estáticas como el caso de la función `func2`:
![gprof-flag](/trabajo1/imagenes/Captura%20desde%202026-03-21%2021-10-27.png)
![gprof-flag-analisys](/trabajo1/imagenes/Captura%20desde%202026-03-21%2021-11-17.png)
![gprof-call-graph](/trabajo1/imagenes/Captura%20desde%202026-03-21%2021-13-10.png)

**Se puede ver que no hay información relacionada con `func2`**

- Usando la flag `-b` se eliminan los textos detallados
![gprof-sintexto](/trabajo1/imagenes/Captura%20desde%202026-03-21%2021-18-21.png)

- Usando el flag `-p` se imprime solo el perfil plano
![gprof-perfilplano](/trabajo1/imagenes/Captura%20desde%202026-03-21%2021-21-15.png)

- Podemos agregar la flag `-pfunc1` para reducir el análisis del programa a una sola función en específico
![gprof-fuincionesespecificas](/trabajo1/imagenes/Captura%20desde%202026-03-21%2021-27-38.png)

### Generación de gráficos
Necesitamos instalar la herramienta `gprof2dot`. Y se realiza el siguiente procedimiento:
![generacion-grafico](/trabajo1/imagenes/Captura%20desde%202026-03-21%2023-43-39.png)

Esta herramienta genera el siguiente gráfico:

![grapviz-grafico](/trabajo1/profiling/grafico.png)

### Uso de la herramiento perf para profiling
Perf utiliza perfiles estadísticos, donde sondea el programa y ve qué función está funcionando. Esto es menos preciso, pero tiene menos impacto en el rendimiento que algo como Callgrind, que rastrea cada llamada. Los resultados siguen siendo razonablemente precisos, e incluso con menos muestras, mostrará qué funciones están tomando mucho tiempo, incluso si pierde funciones que son muy rápidas.

**Procemiento**:
![perf1](/trabajo1/imagenes/Captura%20desde%202026-03-22%2000-03-19.png)
![perf2](/trabajo1/imagenes/Captura%20desde%202026-03-22%2000-04-10.png)
![perf1](/trabajo1/imagenes/Captura%20desde%202026-03-22%2000-04-59.png)

*Interpretación*:
- `func1` consume más de la mitad del tiempo total, es decir, tiene un overhead del 55,45%.
- `func2` tiene un overhead del 37,42%.
- `new_func1` tiene un overhead de 3,45%, es irrelevante.
- `main` es despreciable.
- Todo lo que dice `[unknown]` es código del kernel, interrupciones, scheduler, syscalls. Aparecen porque `perf` mide todo lo que ejecuta el CPU, no solo el programa. Tienen ~0% por lo que son despreciables.


# Modificando la frecuencia de un ESP32

El ESP32 tiene típicamente estas frecuencias:
- 80 MHz
- 160 MHz
- 240 MHz (máxima)

Y se pueden cambiar en tiempo de ejecución.

La idea es hacer dos test:
1. Suma de enteros (int)
2. Suma de floats

Y medir el tiempo en dos situaciones. Primero con una frecuencia de 80 MHz, y luego con el doble de frecuencia, es decir con 160 MHz, y comparar como cambian los tiempos de ejecución.

Se puede ver el código que se va a cargar a la ESP32 [acá](/trabajo1/benchmark_esp32/esp32_benchmarkV1.ino).

Se utilizan variables `volatile` para evitar que el compilador potimice los bucles y los elimine, y `esp_timer_get_time()` para medir con precisión de microsegundos, e incluso mide cuando se cambia la frecuencia en la ejecución del programa.

Resultados:

![Resultados-benchmar-ESP32](/trabajo1/imagenes/Captura%20desde%202026-03-28%2020-26-55.png)

El programa realiza un bucle for donde suma enteros, y otro bucle for donde suma números de punto flotante. Ambos bucles realizan 30 millones de iteraciones.

Cuando la **frecuencia es de 80 MHz**:
- La suma de enteros demora aproximadamente 10.996 segundos
- La suma de flotantes demora aproximadamente 4.930 segundos

Y cuando duplicamos la **frecuencia a 160 MHz** se observa que el tiempo de ejecución se redujo a la mitad aproximadamente:

- La suma de enteros demora aproximadamente 5.467 segundos
- La suma de flotantes demora aproximadamente 2.451 segundos

Que al duplicar la frecuencia el tiempo se reduzca a la mitad implica:

$$T \propto \frac{1}{f}$$

- Más frecuencia equivale a más ciclos por segundo
- Mismo código, por lo tanto tenemos los mismos ciclos totales
- El resultado es menos tiempo

Este resultado es el **caso ideal**. Pero en sistemas reales muchas veces NO pasa esto.
Casos donde no se cumple:
- Acceo a memoria: RAM o Flash no escalan con la frecuencia, se genera un cuello de botella.
- Operaciones más complejas que generan más latencia.
- Interrupciones y/o el sistema operativo. El ESP32 usa FreeRTOS el cual puede tener tareas en background como WiFi/Bluetooth.
- I/O, como Serial o GPIO que no dependen del CPU.