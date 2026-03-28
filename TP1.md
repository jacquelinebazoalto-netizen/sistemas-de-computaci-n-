# Trabajo Práctico 1 - Rendimiento

## 1. Introducción

Los benchmarks pueden clasificarse según el componente que evalúan (CPU, GPU, memoria, almacenamiento), el tipo de prueba (sintéticos o del mundo real), y el objetivo (rendimiento, estrés o consumo).

## 2. Benchmarks utilizados

Los benchmarks más útiles son aquellos que representan de forma más realista las tareas que cada usuario realiza diariamente.

En este caso, los benchmarks más útiles son:

- 3DMark, para evaluar el rendimiento en videojuegos y tareas gráficas.
- HandBrake, para medir el rendimiento en procesamiento de video.
- Cinebench R23, para evaluar el rendimiento general del procesador.
- y-cruncher y C-Ray, para medir cálculos intensivos como los utilizados en simulaciones.
- WebXPRT 4, para evaluar el rendimiento en aplicaciones web.

Estos benchmarks permiten obtener una visión completa del rendimiento del sistema en distintos escenarios.


| Tarea | Benchmark |
|------|----------|
| Ver videos | HandBrake |
| Videojuegos | UL Brenchmarks 3DMark |
| Simulación de circuitos (Multisim, SPICE) | C-Ray |
| Uso general de la PC | CPU-Z |
| Navegación web | ARES-6 |


### 3. Aceleración cuando usamos un AMD Ryzen 9 7950X 16-Core respecto al Intel Core i5-13600K

Aceleracion = $\frac{Rendimiento Mejorado}{Rendimiento Original}$ = $\frac{EXcpu_original}{EXcpu_mejorado}$ = $\frac{1094Seg}{630Seg}$ = 1.73

Intel Core i5-13600K

Eficiencia  = $\frac{1.73}{14 Nucleos}$ = 0.123

AMD Ryzen 9 5900HX 16-Core

Eficiencia  = $\frac{1.73}{16 Nucleos}$ = 0.108

### 4. Aceleración cuando usamos un AMD Ryzen 9 7950X 16-Core respecto al AMD Ryzen 9 5900X 12-Core

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


