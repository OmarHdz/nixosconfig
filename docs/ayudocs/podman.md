# Imagenes
## Gestion
Comandos básicos para manejar imágenes:
podman pull <imagen>       # Descargar imagen
podman images              # Listar imágenes
podman rmi <id_o_nombre>   # Borrar una imagen
podman tag <old> <new>     # Renombrar/etiquetar imagen
podman inspect <imagen>    # Ver detalles (JSON)

## Construccion
Crear imágenes propias:
podman build -t <nombre> .               # Construir desde Dockerfile
podman build -t <nombre> -f <archivo>    # Usar un archivo específico

## Limpiar
Eliminar imágenes sobrantes:
### Prune
podman image prune         # Eliminar imágenes sin usar (dangling)
podman image prune -a      # Eliminar TODAS las imágenes no usadas por contenedores

# Contenedores
## Ejecucion
Crear y arrancar contenedores:
podman run -d --name <nombre> <imagen>   # Ejecutar en segundo plano
podman run -it --name <nombre> <imagen>  # Ejecutar interactivo
podman run -p 8080:80 <imagen>           # Mapear puertos (Host:Contenedor)
podman run -v /host:/cont:Z <imagen>     # Montar volúmenes (:Z para SELinux)

## Estado
Ver qué está pasando:
podman ps                  # Ver contenedores activos
podman ps -a               # Ver todos (incluidos detenidos)
podman logs -f <nombre>    # Ver logs en tiempo real
podman stats               # Ver consumo de CPU y Memoria
podman top <nombre>        # Ver procesos dentro del contenedor

## Acciones
Interactuar con contenedores vivos:
podman stop <nombre>       # Detener
podman start <nombre>      # Iniciar detenido
podman restart <nombre>    # Reiniciar
podman exec -it <nom> bash # Entrar a la terminal del contenedor
podman rm -f <nombre>      # Borrar contenedor (forzado)

# Pods
## Gestion
Administrar grupos de contenedores (Pods):
podman pod create --name <nombre>        # Crear un Pod
podman pod ps                            # Listar Pods
podman pod stop <nombre>                 # Detener todos los contenedores del pod
podman pod rm <nombre>                   # Borrar pod y sus contenedores

## Uso
Ejecutar contenedores dentro de un Pod:
podman run -d --pod <nombre_pod> <imagen> # Añadir contenedor al pod
# Nota: Los contenedores en un mismo Pod comparten localhost y red.

# Volumenes
## Gestion
Persistencia de datos:
podman volume ls           # Listar volúmenes
podman volume create <nom> # Crear volumen
podman volume inspect <nom># Ver ruta en el host
podman volume rm <nom>     # Borrar volumen

# Sistema
## Mantenimiento
Limpieza y diagnóstico:
podman info                # Ver info del sistema y rutas
podman system prune        # Limpiar TODO (cont. detenidos, imágenes huérfanas)
podman system prune -a     # Limpieza profunda (incluye imágenes no usadas)

## Systemd
Generar archivos de servicio para que arranquen con el PC:
### Generar
podman generate systemd --name <cont> --files --new
### Directorio
Los archivos .service se guardan en:
~/.config/systemd/user/
