#!/usr/bin/env bash
#Display network info for phpsysinfo

echo "........................................IPs....................................."
echo "LAN IP: $(hostname -I|cut -d' ' -f1)"
echo "Public IP: $(curl -s4 ifconfig.co)"
echo "..................................\`vcgencmd stats\`.............................."
sudo -upi vcgencmd get_throttled
hex=$(sudo -upi vcgencmd get_throttled|cut -d'x' -f2)
binary=$(echo "ibase=16;obase=2;$hex"|bc)
echo "Binary: $binary";
revbinary=$(echo $binary|rev)
if echo $binary | grep 1 ;then
  echo "ISSUES DETECTED"
  if [ ${revbinary:0:1} -eq 1 &>/dev/null ];then
    echo "Under-voltage detected"
  fi
  if [ ${revbinary:1:1} -eq 1 &>/dev/null ];then
    echo "Arm frequency capped"
  fi
  if [ ${revbinary:2:1} -eq 1 &>/dev/null ];then
    echo "Currently Throttled"
  fi
  if [ ${revbinary:3:1} -eq 1 &>/dev/null ];then
    echo "Soft temperatue limit active"
  fi
  if [ ${revbinary:16:1} -eq 1 &>/dev/null ];then
    echo "Under-voltage has occurred"
  fi
  if [ ${revbinary:17:1} -eq 1 &>/dev/null ];then
    echo "Arm frequency capping has occurred"
  fi
  if [ ${revbinary:18:1} -eq 1 &>/dev/null ];then
    echo "Throttling has occurred"
  fi
  if [ ${revbinary:19:1} -eq 1 &>/dev/null ];then
    echo "Soft temperature limit has occurred"
  fi
fi
echo "....................................Clock Speeds................................"
for i in arm core h264 isp v3d uart pwm emmc pixel vec hdmi dpi;do
  echo -e "${i}:\t$(sudo -upi vcgencmd measure_clock ${i})"
done
echo "........................................Volts..................................."
for i in core sdram_c sdram_i sdram_p;do
  echo -e "${i}:\t$(sudo -upi vcgencmd measure_volts ${i})"
done
echo ".....................................Caddyfile.................................."
cat /etc/caddy/Caddyfile
echo ".................................... Crontab...................................."
cat /etc/crontab | grep -ve '^#'
