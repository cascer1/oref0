# Be very verbose about my customizations running
echo ''
echo ''
echo "  START CAS' MODIFICATIONS  "
echo ''
echo ''

#Ask for github username
read -p "What is your github username? " -r
githubusername=$REPLY

# Configure authorized SSH keys
touch ~/.ssh/authorized_keys
cd ~/.ssh; cp authorized_keys temp.txt; curl -s https://github.com/$githubusername.keys >> temp.txt; awk '!seen[$0] ++' temp.txt > authorized_keys

# Load bash and vim preferences
read -p "Would you like to load Cas' Vim and Bash preferences? (y/N)" -r
loadpreferences=$REPLY
if ["$loadpreferences" == "y"]; then
  bash <(curl -s https://raw.githubusercontent.com/cascer1/dotbash/master/install.sh)
  bash <(curl -s https://raw.githubusercontent.com/cascer1/dotvim/master/install.sh)
fi

# Install required packages
apt-get install -y tmux ethtool ruby2.3 unzip wget

# Gist tool for easy log uploading
gem install gist

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
sed -i -r "s/#*\s*PasswordAuthentication .*/PasswordAuthentication no/g" /setc/ssh/sshd_config

sed -i -r "s/##AUTHTOKEN##/$ngroktoken/g" /usr/local/etc/ngrok.conf
sed -i -r "s/##HOSTNAME##/$ngrokhost/g" /usr/local/etc/ngrok.conf
sed -i -r "s/##SSHPORT##/$sshport/g" /usr/local/etc/ngrok.conf

echo "service ngrok restart" >> /etc/rc.local

# Autotune git logging script
cd /root
mkdir scripts
git clone git@github.com:cascer1/autotune.git
cp ~/src/oref0/cas/autotune-git.sh /root/scripts/autotune-git.sh

# Return to where we were, just to be safe
cd -


echo ''
echo ''
echo "  END CAS' MODIFICATIONS  "
echo ''
echo ''
