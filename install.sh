#!/usr/bin/env bash
set -euo pipefail

# ANSI-färger för snyggare utskrifter
GREEN="\e[32m"
BLUE="\e[34m"
RESET="\e[0m"


print_step_heading() {
    local message="$1"
    local len=$(( ${#message} + 6 ))
    local border=$(printf '#%.0s' $(seq 1 $len))

    # Skapa hela textblocket
    local output="\n$border\n## $message ##\n$border\n"

    # Om lolcat finns, färga det! Annars skriv ut vanligt
    if command -v lolcat &> /dev/null; then
        echo -e "$output" | lolcat
    else
        echo -e "$output"
    fi
}

# Gå till skriptets mapp oavsett varifrån det körs
cd "$(dirname "${BASH_SOURCE[0]}")"


# 
# STEG 0 - GRUNDLÄGGANDE PAKET
#
print_step_heading "Steg 0. Kontrollerar grundläggande beroenden"

# Identifiera pakethanterare och sätt installationskommando
if command -v dnf &> /dev/null; then
    PKG_INSTALL="sudo dnf install -y"
elif command -v apt-get &> /dev/null; then
    echo "Debian/Ubuntu detekterat. Uppdaterar paketlistor..."
    sudo apt-get update -qq
    PKG_INSTALL="sudo apt-get install -y"
else
    echo "Ingen stödd pakethanterare hittades (kräver dnf eller apt-get)."
    exit 1
fi

# Lista på verktyg som behövs
TOOLS=(ansible stow git lolcat)

for cmd in "${TOOLS[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Installerar saknat verktyg: $cmd..."
        $PKG_INSTALL "$cmd"
    fi
done

# 
# STEG 1 - ANSIBLE
#
print_step_heading "Steg 1. Kör Ansible"

ansible-galaxy collection install -r ansible/requirements.yml

ansible-playbook \
  -i ansible/inventory.ini \
  ansible/site.yml \
  --ask-become-pass

# 
# STEG 2 - STOW
# 
print_step_heading "Steg 2. Länkar configs med Stow"

# -v (verbose) är bra för att se exakt vad Stow gör
# -R (restow) ser till att länkar uppdateras korrekt om de redan finns
stow -R -v zsh git kitty ssh

echo -e "\n${GREEN}✔ Installationen slutförd utan fel!${RESET}\n"
