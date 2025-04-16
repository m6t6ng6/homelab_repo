# Restoring apps and configs
echo "Restoring apps and configs"
mkdir -p /apps
cp ./apps/* /apps
cp ./etc/ssh/sshd_config /etc/ssh/sshd_config
systemctl restart sshd

# Restoring crontab
echo "Restoring crontab"
crontab "./crontab_config.txt"
crontab -l
echo "Crontab restored successfully"

echo "====="

echo "Restored successfully"