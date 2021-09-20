#!/bin/bash 

GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
NORMAL=$(tput sgr0)

CURRENT_USER=$(logname)
HOME_DIRECTORY=/home/$CURRENT_USER

printf "\n\n${YELLOW}Прогреваюсь!${NORMAL}\n\n"
sudo apt -y install lsb-release git wget curl
printf "\n${GREEN}Погнали!"

printf "\n\n${YELLOW}Установка TimeShift${NORMAL}\n\n"
sudo apt -y install timeshift
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Создаю резервную копию${NORMAL}\n\n" &
sudo timeshift --create --comments "Резервная копия созданная скриптом"
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Добавляю non-free репы${NORMAL}\n\n"
sudo echo "
# Default
# deb http://mirror.corbina.net/debian/ bullseye main
# deb-src http://mirror.corbina.net/debian/ bullseye main

# deb http://security.debian.org/debian-security bullseye-security main
# deb-src http://security.debian.org/debian-security bullseye-security main

# deb http://mirror.corbina.net/debian/ bullseye-updates main
# deb-src http://mirror.corbina.net/debian/ bullseye-updates main

# Non-free
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free

deb http://mirror.corbina.net/debian bullseye main contrib non-free
deb-src http://mirror.corbina.net/debian bullseye main contrib non-free

deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free
" > /etc/apt/sources.list
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Выполняю установку зависимостей и программ${NORMAL}\n\n"
sudo apt update && sudo apt -y upgrade && sudo apt -y install firmware-linux firefox-esr sddm dwm suckless-tools xclip xorg xterm build-essential fakeroot devscripts micro libx11-dev libxft-dev libxinerama1 libxinerama-dev libasound-dev feh sakura tmux
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Создаю бэкап файла dwm.desktop${NORMAL}\n\n"
sudo cp /usr/share/xsessions/dwm.desktop{,.bak}
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Удаляю dwm установленный через apt${NORMAL}\n\n"
sudo apt -y remove dwm
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Восстанавливаю файл dwm.desktop${NORMAL}\n\n"
sudo mv /usr/share/xsessions/dwm.desktop{.bak,}
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Клонирую репу dwm${NORMAL}\n\n"
cd $HOME_DIRECTORY
git clone https://git.suckless.org/dwm
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Телепортируюсь в каталог dwm${NORMAL}\n\n"
cd $HOME_DIRECTORY/dwm
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Меняю ALT на WIN${NORMAL}\n\n"
sed -i "s/Mod1Mask/Mod4Mask/" config.def.h
sed -i 's/{ "st", NULL }/{ "sakura", NULL }/' config.def.h
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Устанавливаю dwm из исходников${NORMAL}\n\n"
sudo make clean install
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Установка nodejs${NORMAL}\n\n"
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt update
sudo apt -y install nodejs
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Установка postgresql${NORMAL}\n\n"
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt -y install postgresql
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Меняю разрешение экрана и ставлю обои${NORMAL}\n\n"
mkdir -p $HOME_DIRECTORY/Pictures/Background
wget https://wallpaper-house.com/data/out/7/wallpaper2you_171373.jpg -O $HOME_DIRECTORY/Pictures/Background/debian.jpg
echo "
xrandr -s 1920x1080
feh --bg-scale $HOME_DIRECTORY/Pictures/Background/debian.jpg
" >> $HOME_DIRECTORY/.xsessionrc
printf "\n${GREEN}Исполнено!"

printf "\n\n${YELLOW}Скачиваю и устанавливаю Visual Studio Code${NORMAL}\n\n"
mkdir $HOME_DIRECTORY/Downloads

wget https://code.visualstudio.com/sha/download\?build\=stable\&os\=linux-deb-x64 -O $HOME_DIRECTORY/Downloads/vscode-current-version.deb

sudo dpkg -i $HOME_DIRECTORY/Downloads/vscode-current-version.deb

sudo apt -y install -f
sudo apt -y install -f

sudo rm $HOME_DIRECTORY/Downloads/*
printf "\n${GREEN}Исполнено!"


printf "\n\n${YELLOW}Установка nginx${NORMAL}\n\n"
sudo apt -y install gnupg2 ca-certificates debian-archive-keyring

curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

sudo apt update
sudo apt -y install nginx
printf "\n${GREEN}Исполнено!"
