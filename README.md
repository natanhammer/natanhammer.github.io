# Partida da recuperação de servidor

Arquivo `r`: script de partida **público de propósito** — não tem senha, chave nem dado de ninguém. Ele só prepara um
Proxmox recém-instalado, pede login no GitHub e baixa o sistema (privado), que pede a senha do backup.

Uso, no Shell do Proxmox: `wget -qO r natanhammer.github.io/r; bash r`
