## Trabajo Practico N4
## Introducción
## ¿Qué es exactamente un módulo del núcleo? 

Los módulos son fragmentos de código que se pueden cargar y descargar en el kernel según se requiera. Extienden la funcionalidad del kernel sin necesidad de reiniciar el sistema. Por ejemplo, un tipo de módulo es el controlador de dispositivo, que permite que el núcleo acceda al hardware conectado al sistema. Sin módulos, tendríamos que construir kernels monolíticos y agregar nuevas funciones directamente en la imagen del kernel. Además de tener kernels más grandes, esto tiene la desventaja de requerir que reconstruyamos y reiniciemos el kernel cada vez que queramos una nueva funcionalidad.

## ¿Qué es checkinstall y para qué sirve?

Cuando un programa se instala en Linux a partir de su código fuente, generalmente se utilizan comandos como ./configure, make y make install. Sin embargo, este método tiene la desventaja de que el sistema no registra automáticamente qué archivos fueron copiados ni facilita su eliminación posterior. Para solucionar este inconveniente existe CheckInstall, una herramienta que convierte la instalación manual en un paquete instalable, como .deb o .rpm según la distribución utilizada. Gracias a esto, el software puede administrarse mediante el gestor de paquetes del sistema, permitiendo realizar desinstalaciones, actualizaciones y un control más ordenado y seguro de los programas instalados.
## Crear un paquete con CheckInstall: Ejemplo con Hello World

1. **Se instala CheckInstall:**

```bash
sudo apt-get update
sudo apt-get install checkinstall
```

2. **Se escribe el código fuente:**
   Archivo `hello.c`:

```c
#include <stdio.h>
int main() {
    printf("HELLO WORLD!\n");
    return 0;
}
```

3. **Se compila el código fuente:**

```bash
gcc -o hello hello.c
```

4. **Se crea un script de instalación:**
   Archivo `install.sh`:

```bash
#!/bin/bash
cp hello /usr/local/bin/
```

5. **Se hace ejecutable el script e instalá con CheckInstall:**

```bash
chmod +x install.sh
sudo checkinstall --pkgname=hello-world --pkgversion=1.0 --backup=no --deldoc=yes --default ./install.sh
```

La salida de este comando es la siguiente:


## ¿Qué funciones tiene disponible un programa y un módulo ?
Espacio de usuario o espacio del kernel.
Espacio de datos.
Drivers. Investigar contenido de /dev.

## 1¿Qué diferencias se pueden observar entre los dos modinfo ? 
## 2¿Qué divers/modulos estan cargados en sus propias pc? comparar las salidas con las computadoras de cada integrante del grupo. Expliquen las diferencias. Carguen un txt con la salida de cada integrante en el repo y pongan un diff en el informe.
## 3¿cuales no están cargados pero están disponibles? que pasa cuando el driver de un dispositivo no está disponible. 
Correr hwinfo en una pc real con hw real y agregar la url de la información de hw en el reporte. 
## 4¿Qué diferencia existe entre un módulo y un programa  ? 
## 5¿Cómo puede ver una lista de las llamadas al sistema que realiza un simple helloworld en c?
## 6¿Qué es un segmentation fault? ¿Cómo lo maneja el kernel y como lo hace un programa?
## 7¿Se animan a intentar firmar un módulo de kernel ? y documentar el proceso ?  
https://askubuntu.com/questions/770205/how-to-sign-kernel-modules-with-sign-file
Agregar evidencia de la compilación, carga y descarga de su propio módulo imprimiendo el nombre del equipo en los registros del kernel. 
## 8¿Que pasa si mi compañero con secure boot habilitado intenta cargar un módulo firmado por mi? 
Dada la siguiente nota https://arstechnica.com/security/2024/08/a-patch-microsoft-spent-2-years-preparing-is-making-a-mess-for-some-linux-users/ 
## ¿Cuál fue la consecuencia principal del parche de Microsoft sobre GRUB en sistemas con arranque dual (Linux y Windows)?

La principal consecuencia del parche de seguridad aplicado por Microsoft fue que muchos sistemas con arranque dual dejaron de poder iniciar Linux correctamente. Esto ocurrió porque la actualización revocó antiguas claves de firma utilizadas por versiones previas de GRUB y shim, componentes fundamentales en el proceso de arranque seguro de distribuciones Linux. Al actualizar la base de datos de claves confiables de UEFI para corregir vulnerabilidades de seguridad, el firmware comenzó a rechazar cargadores Linux que no contaban con firmas nuevas y válidas. Como resultado, en numerosos equipos el sistema bloqueaba la ejecución de GRUB, mostraba errores de firma inválida o iniciaba directamente Windows, provocando que el arranque dual quedara inutilizable para muchos usuarios.

## ¿Qué implicancia tiene desactivar Secure Boot como solución al problema descrito en el artículo?
Deshabilitar Secure Boot permite iniciar el sistema utilizando cualquier cargador de arranque o kernel sin necesidad de verificar firmas digitales, lo que muchas veces facilita resolver problemas de compatibilidad o arranque. Sin embargo, al hacerlo se elimina una importante medida de seguridad, ya que el firmware deja de comprobar si los componentes de inicio fueron modificados o si provienen de una fuente confiable. Como consecuencia, el sistema queda más expuesto a amenazas como bootkits y rootkits capaces de ejecutarse antes de que cargue el sistema operativo, obteniendo un alto nivel de control y ocultándose con mayor facilidad. Aunque desactivar Secure Boot puede resultar una solución práctica en algunos casos, también implica un riesgo considerable, especialmente en equipos donde la seguridad e integridad de la información son fundamentales, como servidores, entornos empresariales o computadoras personales con datos sensibles.

## ¿Cuál es el propósito principal del Secure Boot en el proceso de arranque de un sistema?
El propósito principal de Secure Boot es proteger el proceso de arranque del sistema evitando la ejecución de software no confiable o malicioso antes de que el sistema operativo se inicie completamente. Esta característica, incorporada en el firmware UEFI, utiliza una serie de claves criptográficas almacenadas en una base de datos de confianza para verificar la autenticidad de cada componente que participa en el arranque. De esta manera, únicamente se permite ejecutar cargadores de arranque, kernels y módulos que estén correctamente firmados digitalmente. Gracias a esta verificación se mantiene una cadena de confianza desde el firmware hasta el kernel del sistema operativo, reduciendo significativamente el riesgo de ataques como bootkits y rootkits persistentes, los cuales intentan instalarse en etapas tempranas del arranque para obtener control total del sistema y permanecer ocultos incluso después de reinstalar el sistema operativo.



