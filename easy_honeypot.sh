#!/usr/bin/env bash

# Constantes para facilitar a utilização das cores.
GREEN='\033[32;1m'
YELLOW='\033[33;1m'
RED_BLINK='\033[31;5;1m'
END='\033[m'

# Função chamada quando cancelar o programa com [Ctrl]+[c]
trap __Ctrl_c__ INT

__Ctrl_c__() {
    __Clear__
    printf "\n${RED_BLINK} [!] Ação abortada!${END}\n\n"
    exit 1
}

toilet -f mono12 -F metal "honeypot"
echo -e "${GREEN} [*]${END} Digite a porta TCP que deseja abrir: "
read porta
echo -e "${GREEN} [*]${END} Digite o banner falso do serviço: "
read banner
echo " "

touch acesso-$porta.log
echo $banner >> banner-$porta.txt
sudo chmod 777 acesso-$porta.log banner-$porta.txt
clear

toilet -f mono12 -F metal "honeypot"
echo -e "${YELLOW} [!] Acompanhe o log de acesso pelo arquivo: ${END}"
varpwd=$(pwd)
echo -e "${GREEN} $varpwd/acesso-$porta.log ${END}"
echo " "
var_ip=$(ifconfig | grep "inet " | grep -v "127.0.0.1" | cut -d "t" -f2 | cut -d "n" -f1 | sed 's/ //')
echo -e "${GREEN} [+] IP DO HONEYPOT:${END} $var_ip"
echo -e "${GREEN} [+] PORTA:${END} $porta"
echo -e "${GREEN} [+] BANNER:${END} $(cat banner-$porta.txt)"
echo " "
echo -e "${GREEN} [*] Escutando...${END}"
while true;do nc -vnlp $porta < banner-$porta.txt 1>>acesso-$porta.log 2>>acesso-$porta.log;echo $(date) >> acesso-$porta.log;done
echo " "
echo -e "${RED_BLINK} [!] A conexao fechou!${END}"
