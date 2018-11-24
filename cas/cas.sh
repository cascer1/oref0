# Configure authorized SSH keys
cd ~/.ssh; cp authorized_keys temp.txt; curl -s https://github.com/cascer1.keys >> temp.txt; awk '!seen[$0] ++' temp.txt > authorized_keys

# Load bash and vim preferences
bash <(curl -s https://raw.githubusercontent.com/cascer1/dotbash/install.sh)
bash <(curl -s https://raw.githubusercontent.com/cascer1/dotvim/install.sh)

# Gist tool for easy log uploading
apt-get install -y git vim ethtool ruby2.3
gem install gist

# Required for installing ngrok
apt-get install -y unzip wget

# Install ngrok
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
unzip ngrok-stable-linux-arm.zip
mv ngrok /usr/local/bin/
chmod +x /usr/local/bin/ngrok

# Ask for ngrok and ssh info
read -p "What SSH port would you like to use? " -r
sshport=$REPLY

read -p "What is your ngrok hostname? " -r
ngrokhost=$REPLY

read -p "What is your ngrok access token? " -r
ngroktoken=$REPLY

# Move required config files into place
cp ~/src/oref0/cas/ngrok.conf /usr/local/etc/ngrok.conf
cp ~/src/oref0/cas/ngrok.service /etc/systemd/system/ngrok.service

# Replace placeholders with actual data in config files
sed -i -r "s/#*\s*Port .*/Port $sshport/g" /etc/ssh/sshd_config
sed -i -r "s/#*\s*PermitRootLogin .*/PermitRootLogin prohibit-password/g" /etc/ssh/sshd_config

sed -i -r 's/##AUTHTOKEN##/$ngroktoken/g' /usr/local/etc/ngrok.conf
sed -i -r 's/##HOSTNAME##/$ngrokhost/g' /usr/local/etc/ngrok.conf
sed -i -r 's/##SSHPORT##/$sshport/g' /usr/local/etc/ngrok.conf

echo "service ngrok restart" >> /etc/rc.local

# Autotune git logging script
cd /root
mkdir scripts
git clone git@github.com:cascer1/autotune.git
cp ~/src/oref0/cas/autotune-git.sh /root/scripts/autotune-git.sh
