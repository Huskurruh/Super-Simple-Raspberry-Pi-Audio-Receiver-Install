#!/bin/bash

echo "Applying my Stretch fix..."
read -p "Bluetooth PIN: " BluetoothPIN
sudo mkdir -p /usr/bin/bluez
sudo sed -i 's|^exit 0|/usr/bin/bluez/setpin.sh\nexit 0\n|' /etc/rc.local
sudo touch /usr/bin/bluez/setpin.sh
sudo cat <<EOT >> /usr/bin/bluez/setpin.sh
#!/bin/sh
hciconfig hci0 piscan
hciconfig hci0 sspmode 0
/usr/bin/python /usr/bin/bluez/simple-agent &
EOT
sudo wget -O simple-agent -o /dev/null https://raw.githubusercontent.com/pauloborges/bluez/master/test/simple-agent
sudo wget -O bluezutils.py -o /dev/null https://raw.githubusercontent.com/pauloborges/bluez/master/test/bluezutils.py
sudo cp simple-agent /usr/bin/bluez/simple-agent
sudo cp bluezutils.py /usr/bin/bluez/bluezutils.py
sudo sed -i "57,61 s/^/#/" /usr/bin/bluez/simple-agent
sudo sed -i "66,66 s/^/#/" /usr/bin/bluez/simple-agent
sudo sed -i "68,68 s/^/#/" /usr/bin/bluez/simple-agent
sudo sed -i "69i \\\t\treturn \""$BluetoothPIN"\"" /usr/bin/bluez/simple-agent
sudo sed -i "62i \\\t\treturn" /usr/bin/bluez/simple-agent
sudo sed -i "s/capability = \"KeyboardDisplay\"/capability = \"NoInputNoOutput\"/g" /usr/bin/bluez/simple-agent

sudo chmod +x /usr/bin/bluez/simple-agent
sudo chmod +x /usr/bin/bluez/setpin.sh