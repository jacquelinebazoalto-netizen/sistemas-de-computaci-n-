

































































































































































































































































































# Flujo de ejecución del sistema

El sistema implementado sigue una arquitectura en capas:

Python (API REST)  
↓  
Obtención de datos (JSON)  
↓  
Programa en C (stdin)  
↓  
Rutina en ensamblador  
↓  
Resultado procesado  
↓  
Salida por consola  
Cada capa cumple una función específica:

- Python: adquisición de datos
- C: interfaz y control de flujo
- ASM: procesamiento de bajo nivel

# Convención utilizada: System V AMD64 ABI

El programa implementado utiliza la convención de llamadas **System V AMD64 ABI**, que es el estándar en sistemas Linux. Esta convención define cómo se pasan los parámetros, cómo se devuelven los valores y qué registros deben preservarse.Esto permite evitar el uso del stack para el pasaje de parámetros simples, optimizando el rendimiento mediante el uso de registros.

# Funcionamiento de las instrucciones call y ret

La instrucción `call` cumple dos funciones fundamentales:

1. Guarda en el stack la dirección de la siguiente instrucción (dirección de retorno).
2. Transfiere el control a la función llamada.

Esto se implementa internamente como:
- `push rip`
- `jmp destino`

Por otro lado, la instrucción `ret`:

1. Extrae la dirección de retorno desde el stack.
2. La carga en el registro `RIP`.


# Uso de registros en la convención AMD64

En la convención System V AMD64 se utilizan registros específicos para el pasaje de parámetros:

- `xmm0` a `xmm7`: para argumentos de punto flotante
- `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`: para enteros y punteros

En este trabajo, el valor GINI se pasa mediante `xmm0`, ya que es un número de punto flotante.

El uso de registros permite reducir accesos a memoria y mejorar el rendimiento.

# Rol del lenguaje ensamblador en el sistema

El lenguaje ensamblador cumple el rol de capa de procesamiento de bajo nivel dentro de una arquitectura multicapa (Python → C → ASM).

A diferencia de los lenguajes de alto nivel, el ensamblador permite interactuar directamente con los recursos del procesador, como registros, instrucciones específicas y el stack. Esto posibilita un control preciso sobre cómo se ejecutan las operaciones.

Además, el uso de ensamblador permite analizar explícitamente:

- El pasaje de parámetros según la convención ABI
- El uso del stack durante la llamada a funciones
- La interacción entre instrucciones de control (`call`, `ret`) y el flujo de ejecución

De esta manera, el ensamblador no solo cumple una función operativa dentro del sistema, sino también un rol clave en la comprensión del funcionamiento interno del software.

## Conclusión

El desarrollo del presente trabajo permitió integrar diferentes niveles de representación del sistema, desde la obtención de datos mediante una API REST en Python hasta su procesamiento en bajo nivel utilizando lenguaje ensamblador.

A lo largo de la implementación se evidenció cómo los lenguajes de alto nivel dependen de mecanismos fundamentales definidos por la arquitectura del procesador, tales como el uso de registros, el stack y las convenciones de llamada. En particular, la utilización de la convención System V AMD64 ABI permitió comprender el pasaje de parámetros mediante registros y el rol del stack en la gestión de llamadas a funciones.

La incorporación de una rutina en ensamblador hizo posible analizar de manera explícita el flujo de ejecución a nivel de CPU, observando el comportamiento de instrucciones como `call` y `ret`, así como el uso de registros específicos (`xmm0`, `eax`) para el intercambio de datos.
