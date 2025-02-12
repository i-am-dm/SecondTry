#!/bin/sh
cd /root
geth init genesis.json
geth --datadir /root \
  --networkid 1999 \
  --http \
  --http.addr 0.0.0.0 \
  --http.api eth,net,web3,personal,admin \
  --http.corsdomain '*' \
  --ws \
  --ws.addr 0.0.0.0 \
  --ws.api eth,net,web3,personal,admin \
  --ws.origins '*' \
  --nodiscover 