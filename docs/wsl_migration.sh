# List distros
wsl -l -v

# Apagar wsl
wsl --shutdown
wsl --terminate <Distribution Name>

# Exportar distribucion actual
wsl --export Ubuntu-20.04 V:\wsl\ubuntu20.tar

# Borrar distribucion
wsl --unregister Ubuntu-20.04

# Borrar distribucion
wsl --import Ubuntu-20.04 V:\wsl\ubuntu20 V:\wsl\ubuntu20.tar --version 2
