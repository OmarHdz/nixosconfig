# Config
## Usuario
Configurar nombre y correo global:
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
Esto se guarda en el archivo ~/.config/git/config

## Listar
Ver todas las configuraciones actuales:
git config --list

# Flujo
## Basico
Comandos iniciales para un repo local:
git init                  # Iniciar repo
git status                # Ver estado de archivos
git add .                 # Indexar todos los cambios
git commit -m "mensaje"   # Crear commit

## Clonar
Clonar un repositorio existente:
git clone <url_del_repo>

# Ramas
## Gestion
Crear, listar y borrar ramas:
git branch                # Listar ramas
git branch <nombre>       # Crear rama
git checkout <nombre>     # Cambiar a una rama
git switch -c <nombre>    # Crear y cambiar (moderno)
git branch -d <nombre>    # Borrar rama (local)

## Fusion
Unir cambios de ramas:
git merge <nombre_rama>   # Fusionar rama en la actual
git rebase <nombre_rama>  # Aplicar commits sobre otra rama

# Historial
## Logs
Visualizar el historial de commits:
git log --oneline         # Resumen de una linea
git log --graph --all     # Ver gráfico de ramas
git log -p <archivo>      # Ver cambios detallados en un archivo

## Diferencias
Comparar cambios:
git diff                  # Cambios no indexados
git diff --staged         # Cambios indexados vs último commit

# Deshacer
## Archivos
Recuperar o descartar cambios:
git checkout -- <archivo>   # Descartar cambios en un archivo
git restore <archivo>       # (Moderno) Descartar cambios

## Commits
Corregir errores en commits:
git commit --amend          # Editar el último commit
git reset --soft HEAD~1     # Deshacer último commit (mantiene cambios)
git reset --hard HEAD~1     # Borrar último commit (pierde cambios)
git revert <hash_commit>    # Crea un commit que deshace otro

# Remoto
## Repositorios
Gestionar conexiones con servidores:
git remote -v               # Ver remotos configurados
git remote add origin <url> # Añadir remoto
git remote remove origin    # Eliminar remoto

## Sincronizar
Subir y bajar cambios:
git push origin <rama>      # Subir cambios
git pull origin <rama>      # Bajar cambios y fusionar
git fetch                   # Descargar info del remoto sin fusionar

# Stash
## Guardar
Guardar cambios temporalmente sin hacer commit:
git stash                   # Guardar
git stash save "mensaje"    # Guardar con mensaje

## Recuperar
Traer de vuelta lo guardado:
git stash list              # Ver lista de stashes
git stash pop               # Aplicar y borrar el último
git stash apply <index>     # Aplicar uno específico sin borrarlo
git stash drop <index>      # Borrar uno específico
