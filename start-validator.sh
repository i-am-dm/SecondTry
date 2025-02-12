#!/bin/sh
cd /root
geth init genesis.json
geth --datadir /root \
  --networkid 1999 \
  --mine \
  --miner.threads=1 \
  --unlock 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 \
  --password /dev/null \
  --allow-insecure-unlock \
  --http \
  --http.addr 0.0.0.0 \
  --http.api eth,net,web3,personal,admin \
  --http.corsdomain '*' \
  --ws \
  --ws.addr 0.0.0.0 \
  --ws.api eth,net,web3,personal,admin \
  --ws.origins '*' \
  --nodiscover 