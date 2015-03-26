# epers-grupo5-rentauto

### Setup del proyecto
- Clonar el proyecto
- Desde Eclipse, ir a **File -> Import... -> Maven -> Existing Maven Projects** y navegar hasta la carpeta del proyecto
- Seleccionarlo y darle **Finish**

### Setup de la DB
Las credenciales se guardan en un archivo fuera del código fuente, para que cada uno pueda tener el usuario y contraseña que quiera. Lo que hay que hacer es crear un archivo _src/main/resources/db.properties_ con el siguiente contenido:

```
jdbc.user=root
jdbc.password=tupassword
```
 
Este archivo ya está ignorado por el _.gitignore_, de modo que nunca se va a subir al repo.