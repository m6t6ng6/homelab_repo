# copy crontab contents
crontab -l | tee crontab_config.txt

# copying apps and configs
echo "Copying /apps"
mkdir -p ./apps/
cp /apps/* ./apps/

echo "Copying /etc/ssh"
mkdir -p ./etc/ssh/
cp /etc/ssh/sshd_config ./etc/ssh/

echo "Showing latest tree"
tree -Dfsh