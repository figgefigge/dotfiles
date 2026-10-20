#!/usr/bin/env bash

# Avbryt skriptet direkt om ett kommando misslyckas
set -e

# Hitta sökvägen till mappen där skriptet ligger (dotfiles/scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Peka ut var din ini-fil finns (ett steg upp till roten, sen till configs/)
SETTINGS_FILE="$SCRIPT_DIR/../gnome-settings.ini"

# Kontrollera att filen finns innan vi försöker importera
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Fel: Kunde inte hitta inställningsfilen på: $SETTINGS_FILE"
    exit 1
fi

echo "Importerar GNOME-inställningar från $SETTINGS_FILE..."

# Importera dconf-databasen
dconf load / < "$SETTINGS_FILE"

echo "GNOME-inställningarna har applicerats utan problem!"


