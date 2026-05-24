## Trabajo Practico N4
## Introducción
## ¿Qué es exactamente un módulo del núcleo? 

Los módulos son fragmentos de código que se pueden cargar y descargar en el kernel según se requiera. Extienden la funcionalidad del kernel sin necesidad de reiniciar el sistema. Por ejemplo, un tipo de módulo es el controlador de dispositivo, que permite que el núcleo acceda al hardware conectado al sistema. Sin módulos, tendríamos que construir kernels monolíticos y agregar nuevas funciones directamente en la imagen del kernel. Además de tener kernels más grandes, esto tiene la desventaja de requerir que reconstruyamos y reiniciemos el kernel cada vez que queramos una nueva funcionalidad.

## ¿Qué es checkinstall y para qué sirve?
¿Se animan a usarlo para empaquetar un hello world ? 
Revisar la bibliografía para impulsar acciones que permitan mejorar la seguridad del kernel, concretamente: evitando cargar módulos que no estén firmados. rootkits ? 

## Responder las siguientes preguntas y sentencias:

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
## 9¿Cuál fue la consecuencia principal del parche de Microsoft sobre GRUB en sistemas con arranque dual (Linux y Windows)?
## 10¿Qué implicancia tiene desactivar Secure Boot como solución al problema descrito en el artículo?
## 11¿Cuál es el propósito principal del Secure Boot en el proceso de arranque de un sistema?
El propósito principal de Secure Boot es proteger el proceso de arranque del sistema evitando la ejecución de software no confiable o malicioso antes de que el sistema operativo se inicie completamente. Esta característica, incorporada en el firmware UEFI, utiliza una serie de claves criptográficas almacenadas en una base de datos de confianza para verificar la autenticidad de cada componente que participa en el arranque. De esta manera, únicamente se permite ejecutar cargadores de arranque, kernels y módulos que estén correctamente firmados digitalmente. Gracias a esta verificación se mantiene una cadena de confianza desde el firmware hasta el kernel del sistema operativo, reduciendo significativamente el riesgo de ataques como bootkits y rootkits persistentes, los cuales intentan instalarse en etapas tempranas del arranque para obtener control total del sistema y permanecer ocultos incluso después de reinstalar el sistema operativo.



