# Allow the main NFS port (2049) on tailscale0
sudo ufw allow in on tailscale0 to any port 2049 proto tcp
sudo ufw allow in on tailscale0 to any port 2049 proto udp

# Allow rpcbind (port 111) if your NFS server dynamically allocates ports for mountd/lockd
sudo ufw allow in on tailscale0 to any port 111 proto tcp
sudo ufw allow in on tailscale0 to any port 111 proto udp

# Reload ufw
sudo ufw reload

# Check active rules
sudo ufw status verbose

echo "-----------------"
echo "Glöm inte att ange tailscales ip-range i /etc/exports \n"
echo "\n"
echo "#/etc/exports Exempel\n"
echo "/mnt/nfs/	100.64.0.0/10(rw)\n"
