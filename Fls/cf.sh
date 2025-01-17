#!/bin/bash

function pointing() {
clear
echo -e "\033[96;1m┌────────────────────────────┐\033[0m "
echo -e "\e[96;1m│\e[0m      POINTING DOMAIN       \e[96;1m│\e[0m"
echo -e "\033[96;1m└────────────────────────────┘\033[0m "
echo -e ""

function ipinput() {
read -p "Input IP vps yg ingin di pointing : " IP
}
ipinput
if [[ -z ${IP} ]]; then
ipinput
fi

sleep 1
echo ""

function dominout() {
read -p "Input nama yg akan menjadi nama domain : " sub
}
dominout

if [[ -z ${sub} ]]; then
dominout
fi

DOMAIN=server-tunnel.my.id
dns=${sub}.${DOMAIN}
CF_KEY=353ca051983f0f6aae579f7aa6448e3dea798
CF_ID=sihabalhadromi@gmail.com
set -euo pipefail
echo ""
echo "Proses Pointing Domain ${dns}..."
sleep 2
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${dns}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${IP}'","ttl":120,"proxied":false}')

clear
echo -e "\033[96;1m┌────────────────────────────┐\033[0m "
echo -e "\e[96;1m│\e[0m      POINTING DOMAIN       \e[96;1m│\e[0m"
echo -e "\033[96;1m└────────────────────────────┘\033[0m "
sleep 1
echo -e "Pointing domain successfully"
sleep 1
echo ""
echo -e "Domain kamu adalah : ${dns}"
sleep 1
echo -e "IP Adress yg terkait : ${IP}"
echo
sleep 2
}

pointing
