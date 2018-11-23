cd ~/.ssh; cp authorized_keys temp.txt; curl -s https://github.com/cascer1.keys >> temp.txt; awk '!seen[$0] ++' temp.txt > authorized_keys

bash <(curl -s https://raw.githubusercontent.com/cascer1/dotbash/install.sh)
bash <(curl -s https://raw.githubusercontent.com/cascer1/dotvim/install.sh)

apt-get install -y git vim ethtool ruby2.3
gem install gist
