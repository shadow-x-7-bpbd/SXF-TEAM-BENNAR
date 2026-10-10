#!/bin/bash
# lang: Bash, file: unstall.sh, target: Termux
# SHADOWXbanner - Uninstaller
clear

r='\033[1;91m'; g='\033[1;92m'; y='\033[1;93m'; c='\033[1;96m'; n='\033[0m'

echo -e " ${r}[!] This will remove SHADOWXbanner completely.${n}"
read -p "$(echo -e ${y}" Are you sure? [y/N]: "${n})" confirm
echo

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo -e " ${g}[+] Uninstall cancelled.${n}"
    exit 0
fi

CONFIG_DIR="$HOME/.shadowxbanner"
THEME="$HOME/.oh-my-zsh/custom/themes/shadowxbanner.zsh-theme"
ZSHRC="$HOME/.zshrc"

[ -d "$CONFIG_DIR" ] && rm -rf "$CONFIG_DIR" && echo -e " ${g}[+] Removed config dir.${n}"
[ -f "$THEME" ]      && rm -f  "$THEME"      && echo -e " ${g}[+] Removed zsh theme.${n}"

if [ -f "$ZSHRC" ]; then
    sed -i '/shadowxbanner/d'            "$ZSHRC"
    sed -i '/sxhelp\|sxbname\|sxart\|sxunstall/d' "$ZSHRC"
    echo -e " ${g}[+] Cleaned .zshrc.${n}"
fi

echo -e "\n ${c}[*] SHADOWXbanner uninstalled. Restart Termux.${n}\n"