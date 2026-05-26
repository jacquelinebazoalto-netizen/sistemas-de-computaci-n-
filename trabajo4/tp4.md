# Laboratorio N° 4: "Modulos de Kernel"
## ¿Se animan a intentar firmar un módulo de kernel ? y documentar el proceso ?  
## Agregar evidencia de la compilación, carga y descarga de su propio módulo imprimiendo el nombre del equipo en los registros del kernel. 
## ¿Que pasa si mi compañero con secure boot habilitado intenta cargar un módulo firmado por mi? 
Si un usuario tiene Secure Boot activado e intenta cargar un módulo firmado por otra persona, el sistema probablemente impida su ejecución si la firma no pertenece a una clave autorizada. Esto ocurre porque Secure Boot verifica que los componentes que se cargan en el arranque, incluidos los módulos del kernel, provengan de fuentes confiables.

En caso de que la clave utilizada para firmar el módulo no esté registrada en el firmware UEFI ni en la base de claves aceptadas del sistema, el kernel rechazará el módulo y mostrará mensajes de error relacionados con la verificación de firmas.

Por el contrario, si la clave pública asociada a esa firma fue previamente agregada como confiable, el módulo podrá cargarse sin inconvenientes aun con Secure Boot habilitado.

Este mecanismo se utiliza para evitar la carga de código no autorizado en el kernel y así mejorar la seguridad del sistema durante el arranque.
