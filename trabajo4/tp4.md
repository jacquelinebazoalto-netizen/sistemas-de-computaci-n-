## 1. ¿Que diferencias se pueden observar entre los dos modinfo?

Se comparó un módulo desarrollado manualmente (`mimodulo.ko`) con un módulo oficial del kernel (`des_generic.ko.xz`):

![modinfo-modulo-desarrollado-manualmente](/trabajo4/img/modinfo-manual.png)
![modinfo-modulo-kernel](/trabajo4/img/modinfo-kernel.png)

**Diferencias observadas**:

### Cantidad de metadata
El módulo `mimodulo.ko` contiene únicamente información básica:
- autor
- descripción
- licencia
- nombre
- versión del kernel (`vermagic`)

En cambio, `des_generic.ko.xz` posee mucha más metadata asociada al módulo.

### Firma digital del módulo
El módulo oficial del kernel incluye información de firma criptográfica:

- `sig_id`
- `signer`
- `sig_key`
- `sig_hashalgo`
- `signature`

Esto indica que el módulo fue firmado digitalmente por **Fedora** usando **PKCS#7** y **SHA256**.

El módulo propio no posee firma digital.

### Módulo oficial vs módulo externo

El módulo `des_generic` contiene:
```bash
intree: Y
```

Esto indica que pertenece al árbol oficial del kernel de Linux (*in-tree module*).

El módulo `mimodulo` no posee ese campo porque fue compilado externamente (*out-of-tree module*).

### Dependencias

El módulo oficial posee dependencias:
```bash
depends: libdes
```

Esto significa que requiere de otros módulos para funciona correctamente.

El módulo propio no depende de ningún otro módulo.

### Aliases

El módulo oficial posee múltiples aliases:
```bash
alias: crypto-des
alias: des
alias: des3_ede
```

Los aliases permiten que el kernel cargue automáticamente el módulo cuando algún componente solicita soporte criptográfico DES.

El módulo propio no posee aliases.

### Compresión del módulo

El móudulo oficial se encuentra comprimido:
```bash
des_generic.ko.xz
```
Fedora comprime muchos módulos del kernel para reducir espacio en disco.

El módulo propio no está comprimido.

### Información en común

Ambos módulos comparten algunos campos:

- licencia GPL
- soporte `retpoline`
- mismo `vermagic`

El `vermagic` indica compatibilidad con la versión actual del kernel.

## 2. ¿Qué drivers/modulos estan cargados en sus propias PC? Comparar las salidas con las computadoras de cada integrante del grupo. Expliquen las diferencias. 

Podemos ver los lsmod de cada integrante en:
- [lsmod-benja](/trabajo4/lsmod_benja.txt)

## 3. ¿Cuales no están cargados pero están disponibles? Que pasa cuando el driver de un dispositivo no está disponible. 

Con el comando
```bash
find /lib/modules/$(uname -r) -name "*.ko*" | less
```

podemos ver los módulos disponibles. Son un montón, adjuntamos los primeros que aparecen:
![primeros-modulo-disponibles](/trabajo4/img/modulos-disponibles-part1.png)

Vamos a verificar que el módulo Bluetooth está disponible en el sistema:
![info-modulo-bluetooth](/trabajo4/img/info-modulo-bluetooth.png)

En efecto se encuentra disponible, pero si revisamos la salida de lsmod en el txt generado en el punto anterior ([lsmod-benja](/trabajo4/lsmod_benja.txt)) veremos que no aparece.

Esto quiere decir que el driver esta disponible en el sistema, pero actualmente no está siendo utilizado/cargado.

Cuando el driver de un dispositivo no está disponible, el sistema operativo no puede comunicarse correctamente con el hardware. Como consecuencia, el dispositivo puede no funcionar o funcionar de manera limitada.

Por ejemplo:
- Una placa de red puede no tener conectividad
- Una GPU puede funcionar sin aceleración gráfica
- Una impresora puede no ser detectada
- El audio puede no funcionar

En Linux, si el módulo existe pero no está cargado, puede cargarse manualmente usando `modprobe`. Si el driver no existe en el sistema, normalmente es necesario instalarlo o compilarlo.

## 4. Correr hwinfo en una pc real con hw real y agregar la url de la información de hw en el reporte. 

Se puede ver el reporte de hwinfo en [hwinfo_reporte](/trabajo4/hwinfo_benja.txt)

## 5. ¿Qué diferencia existe entre un módulo y un programa?

Un programa es una aplicación que se ejecuta en espacio de usuario (*user space*), mientras que un módulo del kernel se ejecuta en espacio del kernel (*kernel space*).

### Programa

* Se ejecuta como un proceso independiente.
* Tiene memoria protegida y aislada.
* Utiliza llamadas al sistema (*syscalls*) para comunicarse con el kernel.
* Si falla normalmente solo termina el proceso.

Ejemplos:

* Firefox
* VLC
* un `helloworld` en C

---

### Módulo del kernel

* Se carga dinámicamente dentro del kernel.
* Tiene acceso directo al hardware y memoria del sistema.
* Extiende funcionalidades del kernel.
* Un error puede comprometer todo el sistema operativo.

Ejemplos:

* drivers WiFi
* drivers GPU
* sistemas de archivos
* módulos criptográficos

---

### Diferencias principales

| Programa                                  | Módulo                      |
| ----------------------------------------- | --------------------------- |
| User space                                | Kernel space                |
| Acceso limitado al hardware               | Acceso completo al hardware |
| Usa syscalls                              | Forma parte del kernel      |
| Más seguro                                | Más riesgoso                |
| Si falla normalmente no afecta al sistema | Puede provocar kernel panic |

---

## 6. ¿Cómo puede ver una lista de las llamadas al sistema que realiza un simple helloworld en C?

Las llamadas al sistema pueden verse utilizando `strace`.

Primero se compila un programa simple:

```c id="hhdlkp"
#include <stdio.h>

int main() {
    printf("Hola mundo\n");
    return 0;
}
```

Compilación:

```bash id="stvhqt"
gcc hola.c -o hola
```

Luego se ejecuta con:

```bash id="lm4xan"
strace ./hola
```

Esto muestra las system calls realizadas por el programa, por ejemplo:

* `open`
* `read`
* `write`
* `mmap`
* `close`
* `exit`

Aunque el programa sea muy simple, el sistema operativo realiza múltiples llamadas al sistema para cargar bibliotecas, reservar memoria y escribir en pantalla.

---

## 7. ¿Qué es un segmentation fault? ¿Cómo lo maneja el kernel y cómo lo hace un programa?

Un *segmentation fault* ocurre cuando un programa intenta acceder a una región de memoria inválida o sin permisos.

Por ejemplo:

* acceder a un puntero NULL
* escribir fuera de un arreglo
* acceder a memoria liberada
* ejecutar memoria no ejecutable

Ejemplo:

```c id="v8l0m9"
int *p = NULL;
*p = 10;
```

Esto genera un `Segmentation Fault`.

---

### ¿Cómo lo maneja el kernel?

El kernel utiliza la MMU (*Memory Management Unit*) y las tablas de páginas para proteger la memoria de cada proceso.

Cuando un proceso accede a memoria inválida:

1. la CPU genera una excepción de hardware (*page fault*)
2. el kernel detecta el acceso inválido
3. el kernel envía la señal `SIGSEGV`
4. normalmente el proceso es finalizado

Esto evita que un proceso dañe memoria de otros procesos o del propio kernel.

---

### ¿Cómo puede manejarlo un programa?

Un programa puede capturar la señal `SIGSEGV` usando manejadores de señales:

```c id="n9bivf"
signal(SIGSEGV, handler);
```

aunque normalmente un segmentation fault indica un bug grave y lo correcto es corregir el error de memoria.

Herramientas útiles para detectar estos errores:

* `gdb`
* `valgrind`
* `AddressSanitizer`
* `strace`
