#!/bin/bash
# FLOW · partida da recuperação do servidor. PÚBLICO de propósito (natanhammer.github.io/r): não tem senha, chave nem
# dado da casa. Só prepara um Proxmox recém-instalado, faz o login no GitHub (código no celular) e baixa o sistema,
# que é PRIVADO e pede a senha do backup (a do papel).
# Na folha impressa:   wget -qO r natanhammer.github.io/r; bash r
# Cópia mestre: flow-backup-sistema/recuperacao/partida.sh (o site público é só uma cópia dela).
set -euo pipefail
echo; echo "== FLOW · recuperação do servidor"; echo
[ "$(id -u)" = 0 ] || { echo "rode no Shell do Proxmox (root)"; exit 1; }
command -v pct >/dev/null || { echo "isto é para um Proxmox recém-instalado"; exit 1; }

# Proxmox sem assinatura: o repositório "enterprise" dá erro no apt. Desliga (renomeia, não apaga) e usa o público.
for f in /etc/apt/sources.list.d/pve-enterprise.sources /etc/apt/sources.list.d/ceph.sources; do
  [ -f "$f" ] && mv "$f" "$f.desligado"
done
if ! grep -rqs "pve-no-subscription" /etc/apt/sources.list.d/; then
  . /etc/os-release
  printf 'Types: deb\nURIs: http://download.proxmox.com/debian/pve\nSuites: %s\nComponents: pve-no-subscription\nSigned-By: /usr/share/keyrings/proxmox-archive-keyring.gpg\n' \
    "$VERSION_CODENAME" > /etc/apt/sources.list.d/proxmox.sources
fi
echo "== instalando o GitHub (gh)"
apt-get update -qq && apt-get install -y -qq gh git >/dev/null

echo; echo "== login no GitHub: vai aparecer um CÓDIGO."
echo "   No celular, abra  github.com/login/device  e digite o código (conta natanhammer)."
echo
gh auth status >/dev/null 2>&1 || gh auth login --hostname github.com --git-protocol https --web < /dev/tty
rm -rf /root/flow-recuperacao
gh repo clone natanhammer/flow-backup-sistema /root/flow-recuperacao -- -q
exec bash /root/flow-recuperacao/recuperacao/recuperar.sh "$@"
