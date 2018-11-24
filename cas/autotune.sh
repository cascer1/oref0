cp /root/myopenaps/autotune/profile.json /root/autotune/profile.json
cp /root/myopenaps/autotune/profile.pump.json /root/autotune/profile.pump.json
tail -n 28 /var/log/openaps/autotune.log > /root/autotune/autotune.log

cd /root/autotune
git commit -a -m "Autotune update for `date`"
git push origin master --force
