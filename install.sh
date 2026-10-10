#!/data/data/com.termux/files/usr/bin/bash
# lang: Bash, file: install.sh, target: Termux/Android
# SHADOWXbanner - Ultimate Terminal Setup (Interactive Installer)

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
OBJ="$DIR/files"
G="\033[1;32m"; C="\033[1;36m"; R="\033[1;31m"; W="\033[1;37m"; Y="\033[1;33m"; RS="\033[0m"

IS_TERMUX=false
[ -d "/data/data/com.termux/files/usr/" ] && IS_TERMUX=true

clear
echo -e "${C}══════════════════════════════════════════════${RS}"
echo -e "${G}       SHADOWXbanner — INTERACTIVE INSTALLER${RS}"
echo -e "${C}══════════════════════════════════════════════${RS}"
echo ""

read -p "$(echo -e ${W}"[?] Enter banner text (Figlet): "${RS})" banner_text
[ -z "$banner_text" ] && banner_text="SHADOWXbanner"

read -p "$(echo -e ${W}"[?] Enter prompt username: "${RS})" prompt_user
[ -z "$prompt_user" ] && prompt_user="SHADOWXbanner"
prompt_user="${prompt_user^^}"
prompt_user="${prompt_user// /-}"

read -p "$(echo -e ${W}"[?] Enter host name (default: termux): "${RS})" prompt_host
[ -z "$prompt_host" ] && prompt_host="termux"

echo ""
echo -e "${Y}[*] Banner : ${banner_text}${RS}"
echo -e "${Y}[*] Prompt : [${prompt_user}@${prompt_host}]${RS}"
echo ""

echo -e "${C}[*] Installing required packages...${RS}"
if $IS_TERMUX; then
    pkg update -y >/dev/null 2>&1
    pkg install -y zsh figlet git curl ruby ncurses-utils >/dev/null 2>&1
else
    sudo apt update -y >/dev/null 2>&1
    sudo apt install -y zsh figlet git curl ruby ncurses-bin >/dev/null 2>&1
fi
if ! command -v lolcat >/dev/null 2>&1; then
    gem install lolcat >/dev/null 2>&1 || echo -e "${R}[!] lolcat failed. Using plain colors.${RS}"
fi

echo -e "${C}[*] Installing Oh My Zsh + plugins...${RS}"
[ ! -d "$HOME/.oh-my-zsh" ] && git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" >/dev/null 2>&1
[ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ] && git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" >/dev/null 2>&1
[ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ] && git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" >/dev/null 2>&1

if $IS_TERMUX; then
    FIGLET_DIR="$PREFIX/share/figlet"
else
    FIGLET_DIR="/usr/share/figlet"
    sudo mkdir -p "$FIGLET_DIR"
fi
mkdir -p "$FIGLET_DIR" 2>/dev/null || sudo mkdir -p "$FIGLET_DIR"
if $IS_TERMUX; then
    cp "$OBJ/ANSI Shadow.flf" "$FIGLET_DIR/SHADOWXbanner.flf"
else
    sudo cp "$OBJ/ANSI Shadow.flf" "$FIGLET_DIR/SHADOWXbanner.flf"
fi

if $IS_TERMUX; then
    mkdir -p "$HOME/.termux"
    cp "$OBJ/colors.properties" "$HOME/.termux/colors.properties"
    cp "$OBJ/termux.properties" "$HOME/.termux/termux.properties"
    termux-reload-settings 2>/dev/null || true
fi

CONFIG_DIR="$HOME/.shadowxbanner"
mkdir -p "$CONFIG_DIR/bin"
cat > "$CONFIG_DIR/config" << EOF
SHADOWX_USER="$prompt_user"
SHADOWX_HOST="$prompt_host"
SHADOWX_BANNER="$banner_text"
EOF

cp "$OBJ/help.sh"    "$CONFIG_DIR/bin/help.sh"
cp "$OBJ/bname.sh"   "$CONFIG_DIR/bin/bname.sh"
cp "$OBJ/unstall.sh" "$CONFIG_DIR/bin/unstall.sh"
cp "$OBJ/art.sh"     "$CONFIG_DIR/bin/art.sh"
chmod +x "$CONFIG_DIR/bin/"*.sh

BANNER_SCRIPT="$CONFIG_DIR/banner.sh"
cat > "$BANNER_SCRIPT" << 'BEOF'
#!/data/data/com.termux/files/usr/bin/bash

clear
FIGLET_DIR="FIGLET_DIR_PLACEHOLDER"
W=$COLUMNS
[ -z "$W" ] && W=80

BOX_TOP="╔$(printf '═%.0s' $(seq 1 $((W-2))))╗"
BOX_BOT="╚$(printf '═%.0s' $(seq 1 $((W-2))))╝"
SEP="║$(printf '─%.0s' $(seq 1 $((W-2))))║"

if command -v figlet >/dev/null 2>&1; then
    BANNER=$(figlet -d "$FIGLET_DIR" -c -f SHADOWXbanner -w $W "BANNER_TEXT_PLACEHOLDER" 2>/dev/null)
else
    BANNER="  BANNER_TEXT_PLACEHOLDER"
fi

echo -e "\033[1;36m${BOX_TOP}\033[0m"

if command -v lolcat >/dev/null 2>&1; then
    echo "$BANNER" | lolcat -F 0.3 2>/dev/null
else
    echo -e "\033[1;32m${BANNER}\033[0m"
fi

echo -e "\033[1;36m${SEP}\033[0m"

LEFT="   SXF TEAM"
RIGHT="OWNED BY SHADOW X   "
LEFT_LEN=${#LEFT}
RIGHT_LEN=${#RIGHT}
MID=$(( W - LEFT_LEN - RIGHT_LEN - 2 ))
[ $MID -lt 0 ] && MID=0
MIDDLE_PAD=$(printf ' %.0s' $(seq 1 $MID))
printf "\033[1;36m║\033[1;93m%s\033[0m%s\033[1;91m%s\033[1;36m║\033[0m\n" "$LEFT" "$MIDDLE_PAD" "$RIGHT"

echo -e "\033[1;36m${SEP}\033[0m"

printf "\n\033[1;37m   SYSTEM: \033[1;32mONLINE\033[1;37m   |   USER: \033[1;31mUSER_PLACEHOLDER\033[0m\n"
printf "\033[1;37m   HOST   : \033[1;36mHOST_PLACEHOLDER\033[0m\n"
printf "\033[1;37m   TYPE '\033[1;33msxhelp\033[1;37m' FOR COMMAND LIST\033[0m\n"
echo -e "\033[1;36m${BOX_BOT}\033[0m"
echo ""
BEOF

sed -i "s|FIGLET_DIR_PLACEHOLDER|$FIGLET_DIR|g"     "$BANNER_SCRIPT"
sed -i "s|BANNER_TEXT_PLACEHOLDER|$banner_text|g"   "$BANNER_SCRIPT"
sed -i "s|USER_PLACEHOLDER|$prompt_user|g"          "$BANNER_SCRIPT"
sed -i "s|HOST_PLACEHOLDER|$prompt_host|g"          "$BANNER_SCRIPT"
chmod +x "$BANNER_SCRIPT"

mkdir -p "$HOME/.oh-my-zsh/custom/themes"
THEME_FILE="$HOME/.oh-my-zsh/custom/themes/shadowxbanner.zsh-theme"
cat > "$THEME_FILE" << EOF
autoload -U colors && colors
setopt prompt_subst

function parse_git_status() {
    git rev-parse --is-inside-work-tree &>/dev/null || return
    local branch
    branch=\$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n \$(git status --porcelain 2>/dev/null) ]]; then
        echo " %{\$fg_bold[red]%}(\${branch}*)%{\$reset_color%}"
    else
        echo " %{\$fg_bold[green]%}(\${branch})%{\$reset_color%}"
    fi
}

local user_info="%{\$fg_bold[red]%}[%{\$fg_bold[green]%}${prompt_user}%{\$fg_bold[red]%}@%{\$fg_bold[white]%}${prompt_host}%{\$fg_bold[red]%}]"
local current_dir="%{\$fg_bold[red]%}[%{\$fg_bold[cyan]%}%(5~|%-1~/…/%2~|%4~)%{\$fg_bold[red]%}]"
local git_info='\$(parse_git_status)'

PROMPT="
%{\$fg_bold[red]%}╔══\${user_info}%{\$fg_bold[red]%}══\${current_dir}\${git_info}
%{\$fg_bold[red]%}╚══➤ %{\$reset_color%}"
EOF

cat > "$HOME/.zshrc" << EOF
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="shadowxbanner"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source \$ZSH/oh-my-zsh.sh

alias sxhelp="bash \$HOME/.shadowxbanner/bin/help.sh"
alias sxbname="bash \$HOME/.shadowxbanner/bin/bname.sh"
alias sxunstall="bash \$HOME/.shadowxbanner/bin/unstall.sh"
alias sxart="bash \$HOME/.shadowxbanner/bin/art.sh"

bash \$HOME/.shadowxbanner/banner.sh
EOF

chsh -s zsh >/dev/null 2>&1 || true

echo ""
echo -e "${G}[+] SHADOWXbanner installed successfully!${RS}"
echo -e "${W}[*] Banner  : ${banner_text}${RS}"
echo -e "${W}[*] Prompt  : [${prompt_user}@${prompt_host}] >>>${RS}"
echo -e "${W}[*] Shell   : Zsh + Autosuggestions + Syntax Highlighting${RS}"
echo -e "${W}[*] Commands: sxhelp, sxbname, sxart, sxunstall${RS}"
echo -e "${Y}[*] Restart Termux or run: zsh${RS}"
echo ""
