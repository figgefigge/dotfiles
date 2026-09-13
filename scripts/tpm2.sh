

sudo dnf install clevis clevis-luks clevis-dracut clevis-udisks2 clevis-systemd
sudo dracut -fv --regenerate-all
sudo systemctl reboot

sudo clevis luks bind -d /dev/nvme... tpm2 '{"pcr_ids":"1,4,5,7,9"}'




