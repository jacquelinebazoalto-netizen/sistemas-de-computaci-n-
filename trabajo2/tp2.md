# Trabajo Práctico N° 2: Calculadora de Íncides GINI
                                                                               
## Objetivo                                                                     
---                                                                            
El objetivo de esta etapa es establecer la comunicación entre una capa escrita en Python, encargada de obtener datos desde una API REST, y un programa escrito en C, encargado de recibirlos y procesarlos. 
Esta división en capas es la base sobre la que luego se integrará una rutina en lenguaje ensamblador que realizará cálculos sobre los datos obtenidos del índice GINI.

### Flujo de ejecución del sistema

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

### Convención utilizada: System V AMD64 ABI

El programa implementado utiliza la convención de llamadas **System V AMD64 ABI**, que es el estándar en sistemas Linux. Esta convención define cómo se pasan los parámetros, cómo se devuelven los valores y qué registros deben preservarse.Esto permite evitar el uso del stack para el pasaje de parámetros simples, optimizando el rendimiento mediante el uso de registros.

### Funcionamiento de las instrucciones call y ret

La instrucción `call` cumple dos funciones fundamentales:

1. Guarda en el stack la dirección de la siguiente instrucción (dirección de retorno).
2. Transfiere el control a la función llamada.

Esto se implementa internamente como:
- `push rip`
- `jmp destino`

Por otro lado, la instrucción `ret`:

1. Extrae la dirección de retorno desde el stack.
2. La carga en el registro `RIP`.


### Uso de registros en la convención AMD64

En la convención System V AMD64 se utilizan registros específicos para el pasaje de parámetros:

- `xmm0` a `xmm7`: para argumentos de punto flotante
- `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`: para enteros y punteros

En este trabajo, el valor GINI se pasa mediante `xmm0`, ya que es un número de punto flotante.

El uso de registros permite reducir accesos a memoria y mejorar el rendimiento.

### Rol del lenguaje ensamblador en el sistema

El lenguaje ensamblador cumple el rol de capa de procesamiento de bajo nivel dentro de una arquitectura multicapa (Python → C → ASM).

A diferencia de los lenguajes de alto nivel, el ensamblador permite interactuar directamente con los recursos del procesador, como registros, instrucciones específicas y el stack. Esto posibilita un control preciso sobre cómo se ejecutan las operaciones.

Además, el uso de ensamblador permite analizar explícitamente:

- El pasaje de parámetros según la convención ABI
- El uso del stack durante la llamada a funciones
- La interacción entre instrucciones de control (`call`, `ret`) y el flujo de ejecución

De esta manera, el ensamblador no solo cumple una función operativa dentro del sistema, sino también un rol clave en la comprensión del funcionamiento interno del software.

## Desarrollo
---
**Obtención de datos**: `fetch_gini()` (Python)                                   
                                                                               
Los datos del índice GINI de Argentina se obtienen de la API pública del Banco Mundial, que no requiere autenticación. El endpoint utilizado es: https://api.worldbank.org/v2/country/AR/indicator/SI.POV.GINI 

Se realizó una solicitud HTTP GET con los parámetros `format=json` y `mrv=10`, donde `mrv` (most recent values) indica que se quieren las 10 mediciones más recientes disponibles.

La API responde con una lista de dos elementos: el primero contiene metadata (número de página, total de resultados, etc.) y el segundo contiene la lista de mediciones. Cada medición incluye el año (date) y el valor del índice (value). Dado que algunos años no cuentan con datos relevados, se filtran los registros cuyo value sea null, conservando únicamente los que tienen un valor válido.                      
**La función retorna una lista de tuplas (año, valor).**
                                           
---

Comunicación entre Python y C — `enviar_a_c()` (Python)                        
                                                        
Para entregar los datos al programa en C se utilizó el módulo subprocess de Python, que permite lanzar un proceso externo (el ejecutable compilado de C) y comunicarse con él a través de su entrada estándar (`stdin`).

Se eligió este mecanismo porque es simple, directo y no requiere modificar la interfaz del programa en C más allá de leer desde stdin, que es el comportamiento estándar.             

El formato de los datos enviados es texto plano estructurado de la siguiente
manera:          
```
N                
año1 valor1
año2 valor2      
...
```                                      

Donde `N` es la cantidad de mediciones. Esta primera línea le indica al programa en C cuántas líneas deberá leer a continuación, evitando que tenga que detectar el fin de entrada por otro medio. Los valores se formatean con 6 decimales para que `scanf` en C los pueda leer sin errores.

---              

Recepción y visualización de datos — `main.c` (C)
                                                  
El programa en C lee los datos desde `stdin` usando `scanf`. 
Primero lee el entero `N`, luego reserva memoria dinámica con `malloc` para un array de `N` estructuras de tipo `Medicion`, cada una con un campo `anio` (entero) y un campo `valor` (`float`).

```c
typedef struct {
    int   anio;  
    float valor;                         
} Medicion;
```

El uso de `malloc` permite que el tamaño del array sea determinado en tiempo de ejecución según la cantidad de registros recibidos, en lugar de definir un tamaño fijo en tiempo de compilación. Una vez finalizado el uso del array, la memoria se libera con `free`.         
    
Finalmente, el programa recorre el array e imprime los datos en formato tabular por consola. **En esta etapa el objetivo es únicamente verificar que los datos llegaron correctamente**. En la siguiente etapa este bloque de
impresión será reemplazado por una llamada a una rutina en ensamblador que realizará los cálculos.

---

*Ahora se viene la magia del noble y querido lenguaje ensamblador*... 

Rutina de ensamblador — `gini_asm.asm`

Para integrar la capa de ensamblador se creó el archivo `gini_asm.asm` (sintaxis NASM), que expone la función `convertir_gini`. Su propósito es recibir un valor GINI como número de punto flotante de precisión simple, convertirlo a entero y sumarle 1, devolviendo el resultado al programa en C.

Firma C equivalente:
```c
int convertir_gini(float valor);
```


**Convención de llamada (System V AMD64 ABI)**

1. El primer argumento de tipo `float` se pasa en el registro `xmm0`. 
2. El valor de retorno entero se devuelve en `eax`. 
3. La función no utiliza variables locales ni llama a otras funciones, por lo que no es necesario preservar registros callee-saved ni ajustar el stack.

Instrucciones utilizadas:
```asm
cvtss2si eax, xmm0
```
Convierte un float de 32 bits (single-precision) en xmm0 a un entero de 32
bits en eax, con truncamiento hacia cero (equivalente al cast (int) en C).


```asm
add eax, 1
```
Suma 1 al entero resultante.


Código fuente:
```asm
section .text
global convertir_gini

convertir_gini:
    cvtss2si eax, xmm0
    add      eax, 1
    ret
```
---

Integración C ↔ Ensamblador — `main.c` actualizado

Se agregó la declaración `extern` de `convertir_gini` en `main.c` para que el compilador conozca la firma de la función sin poseer su implementación:
```c
extern int convertir_gini(float valor);
```

En el bucle de impresión, en lugar de mostrar el float recibido, se invoca la rutina de ensamblador por cada medición:
```c
int convertido = convertir_gini(mediciones[i].valor);
```
El resultado se muestra junto al valor original, permitiendo verificar que la
conversión y la suma son correctas.

---

Para compilar y ejecutar:
```bash
nasm -f elf64 -g -F dwarf -o gini_asm.o gini_asm.asm
gcc -g3 -O0 -no-pie -o gini_c main.c gini_asm.o
python3 fetch_gini.py
```
Al ejecutar, Python obtiene los datos de la API, los envía al proceso C, y este muestra tanto el valor GINI original como el resultado devuelto por la rutina de ensamblador:

![](/trabajo2/imagenes/resultados_py_c_asm.png)

---

### Depuración con GDB — Estado del stack antes, durante y después de `convertir_gini`

La consigna requiere mostrar el área de memoria del stack en tres momentos de la llamada a la rutina de ensamblador. Para lograr esto se compiló con símbolos de depuración (`-g3 -O0` en gcc, `-g -F dwarf` en nasm) y se utilizó el script `gdb_session.gdb` con GDB en modo batch.

```bash
gdb -batch -x gdb_session.gdb ./gini_c
```

#### Secuencia de instrucciones relevante en `main`

El compilador genera las siguientes instrucciones para la llamada:

```asm
0x40063f <main+377>:  movd   %eax, %xmm0        ; copia los bits del float a xmm0
0x400643 <main+381>:  call   0x4006d0 <convertir_gini>  ; empuja retaddr, salta
0x400648 <main+386>:  mov    %eax, -0x14(%rbp)   ; guarda el resultado
```

---

#### PUNTO 1 — ANTES del `call`

Breakpoint en `0x400643` (el `call` mismo). En este momento `xmm0` ya tiene el argumento
float pero la dirección de retorno **no está en el stack todavía**.

```
rsp = 0x7fffffffd5c0
rbp = 0x7fffffffd5e0

xmm0 (argumento):  42.4000015  (float de precisión simple)

Stack desde RSP:
0x7fffffffd5c0:  0x0000000000000000  0x0000000000000003
0x7fffffffd5d0:  0x0000000000405320  0x0000000300000000
0x7fffffffd5e0:  0x00007fffffffd680  0x00007ffff7dac5b5
0x7fffffffd5f0:  0x00007ffff7fc5000  0x00007fffffffd708

Próximas instrucciones:
=> 0x400643 <main+381>:  call   0x4006d0 <convertir_gini>
   0x400648 <main+386>:  mov    %eax, -0x14(%rbp)
```

---

#### PUNTO 2 — DURANTE: primera instrucción de `convertir_gini`

Tras ejecutar el `call`, el procesador **decrementó RSP en 8** y escribió la dirección
de retorno (`0x400648`) en la nueva cima del stack. Ahora estamos en la instrucción
`cvtss2si` de la rutina de ensamblador.

```
rsp = 0x7fffffffd5b8   ← RSP_anterior − 8
rbp = 0x7fffffffd5e0   (sin cambio; no hay prólogo en esta función)

xmm0 (argumento intacto):  42.4000015

Stack desde RSP — [RSP] es la dirección de retorno:
0x7fffffffd5b8:  0x0000000000400648  ← dirección de retorno a main+386
                 0x0000000000000000
0x7fffffffd5c8:  0x0000000000000003  0x0000000000405320
0x7fffffffd5d8:  0x0000000300000000  0x00007fffffffd680
0x7fffffffd5e8:  0x00007ffff7dac5b5  0x00007ffff7fc5000

Disassembly de convertir_gini:
=> 0x4006d0 <+0>:  cvtss2si %xmm0, %eax   ; float → int (truncado)
   0x4006d4 <+4>:  add    $0x1, %eax       ; suma 1
   0x4006d7 <+7>:  ret                     ; retorna
```

**Ejecución de las instrucciones:**

| Instrucción | Efecto | Valor en `eax` |
|---|---|---|
| `cvtss2si %xmm0, %eax` | convierte 42.4 → 42 (trunca hacia cero) | `0x2a` = **42** |
| `add $0x1, %eax` | suma 1 | `0x2b` = **43** |
| `ret` | desapila retaddr en RIP, RSP += 8 | — |

---

#### PUNTO 3 — DESPUÉS del `ret`: de vuelta en `main`

El `ret` desapiló la dirección de retorno (`0x400648`) en `RIP` y restauró `RSP` a su
valor original. El resultado se encuentra en `eax`/`rax`.

```
rsp = 0x7fffffffd5c0   ← restaurado, igual que en PUNTO 1
rbp = 0x7fffffffd5e0

rax = 0x2b = 43        ← resultado devuelto por convertir_gini

Stack restaurado (idéntico al PUNTO 1):
0x7fffffffd5c0:  0x0000000000000000  0x0000000000000003
0x7fffffffd5d0:  0x0000000000405320  0x0000000300000000
0x7fffffffd5e0:  0x00007fffffffd680  0x00007ffff7dac5b5
0x7fffffffd5f0:  0x00007ffff7fc5000  0x00007fffffffd708
```

---

#### Análisis del comportamiento del stack

El ciclo de vida completo de la llamada ilustra la convención **System V AMD64 ABI**:

1. **Paso de argumento**: el compilador carga el float en `xmm0` (registro de punto
   flotante designado para el primer argumento de tipo `float`/`double`).
2. **`call`**: empuja la dirección de la siguiente instrucción (`0x400648`) en el stack
   y decrementa `RSP` en 8. La pila crece hacia direcciones más bajas.
3. **Cuerpo de la función**: `convertir_gini` no usa prólogo (`push %rbp` / `mov %rsp,%rbp`)
   porque no tiene variables locales. Lee el argumento directamente de `xmm0` y escribe
   el resultado en `eax`.
4. **`ret`**: desapila la dirección de retorno en `RIP` e incrementa `RSP` en 8,
   restaurando la pila al estado exacto del PUNTO 1.
5. **Lectura del resultado**: `main` lee `eax` inmediatamente después del `call`
   (`mov %eax, -0x14(%rbp)`) y lo almacena en la variable local `convertido`.
   
## Conclusión

El desarrollo del presente trabajo permitió integrar diferentes niveles de representación del sistema, desde la obtención de datos mediante una API REST en Python hasta su procesamiento en bajo nivel utilizando lenguaje ensamblador.

A lo largo de la implementación se evidenció cómo los lenguajes de alto nivel dependen de mecanismos fundamentales definidos por la arquitectura del procesador, tales como el uso de registros, el stack y las convenciones de llamada. En particular, la utilización de la convención System V AMD64 ABI permitió comprender el pasaje de parámetros mediante registros y el rol del stack en la gestión de llamadas a funciones.

La incorporación de una rutina en ensamblador hizo posible analizar de manera explícita el flujo de ejecución a nivel de CPU, observando el comportamiento de instrucciones como `call` y `ret`, así como el uso de registros específicos (`xmm0`, `eax`) para el intercambio de datos.
