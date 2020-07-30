#!/bin/bash

echo [Unit] | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo Description=RC Service | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo [Service] | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo User=$1 | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo ExecStart=/usr/bin/java -jar /usr/bin/rc/rc.jar | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo SuccessExitStatus=143 | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo TimeoutStopSec=10 | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo RestartSec=10 | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo Restart=on-failure | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo RestartSec=5 | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo [Install] | sudo tee -a /etc/systemd/system/rtc.service > /dev/null
echo WantedBy=multi-user.target | sudo tee -a /etc/systemd/system/rtc.service > /dev/null

sudo chmod 664 /etc/systemd/system/rtc.service
sudo systemctl daemon-reload
sudo systemctl enable rtc.service
