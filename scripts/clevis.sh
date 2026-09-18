#!/usr/bin/env bash
set -euo pipefail

SYSTEM_LUKS_DRIVE="/dev/nvme0n1p3"
BIND_TO_PCRS="1,4,5,7,9"

# 1. Installera paket
echo "Installerar Clevis..."
sudo dnf install -y clevis clevis-luks clevis-dracut clevis-udisks2 clevis-systemd

# Verifiering: kontrollera att kommandot finns
clevis --version

# 2. Binda LUKS till TPM2 (frågar efter din nuvarande LUKS-lösenfras interaktivt)
echo "Binder ${SYSTEM_LUKS_DRIVE} till TPM2..."
sudo clevis luks bind -d "$SYSTEM_LUKS_DRIVE" tpm2 "{\"pcr_ids\":\"${BIND_TO_PCRS}\"}"

# Verifiering: lista aktiva slots/pins på enheten
echo "Verifierar slots:"
sudo clevis luks list -d "$SYSTEM_LUKS_DRIVE"

# 3. Regenerera initramfs
echo "Regenererar initramfs..."
sudo dracut -fv --regenerate-all

echo "Klar! Starta om datorn för att verifiera att TPM2 låser upp disken automatiskt."


# TODO: Kolla först om clevis-pin finns för enheten, isf rebind
