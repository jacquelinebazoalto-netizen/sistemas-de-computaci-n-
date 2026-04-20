# Trabajo Práctico N° 2: Calculadora de Íncides GINI
        
                                                                               
### Objetivo                                                                     
---                                                                            
El objetivo de esta etapa es establecer la comunicación entre una capa escrita en Python, encargada de obtener datos desde una API REST, y un programa escrito en C, encargado de recibirlos y procesarlos. 
Esta división en capas es la base sobre la que luego se integrará una rutina en lenguaje ensamblador que realizará cálculos sobre los datos obtenidos del índice GINI.

### Desarrollo
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
nasm -f elf64 -o gini_asm.o gini_asm.asm
gcc -no-pie -o gini_c main.c gini_asm.o
python3 fetch_gini.py
```
Al ejecutar, Python obtiene los datos de la API, los envía al proceso C, y este muestra tanto el valor GINI original como el resultado devuelto por la rutina de ensamblador:

![](/trabajo2/imagenes/resultados_py_c_asm.png)

