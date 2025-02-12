#!/bin/bash

# Create the network if it doesn't exist
docker network create ethereum 2>/dev/null || true

# Clean up any existing data directories
rm -rf validator node1 node2

# Create data directories
mkdir -p validator node1 node2

# Create password file
echo "" > password.txt

# Create account for validator
echo "Creating validator account..."
ACCOUNT=$(docker run --rm \
  -v $(pwd)/validator:/root/.ethereum \
  -v $(pwd)/password.txt:/password.txt \
  ethereum/client-go:v1.13.14 \
  account new --password /password.txt | grep -o '0x[0-9a-fA-F]\{40\}')

echo "Created account: $ACCOUNT"

# Update genesis.json with the new account
ACCOUNT_NO_PREFIX=${ACCOUNT#0x}
EXTRA_DATA="0x0000000000000000000000000000000000000000000000000000000000000000${ACCOUNT_NO_PREFIX}0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
sed -i '' "s|\"extradata\":.*|\"extradata\": \"$EXTRA_DATA\",|" genesis.json
sed -i '' "s|\"alloc\":.*|\"alloc\": {|" genesis.json
sed -i '' "s|\"[0-9a-fA-F]\{40\}\":.*|\"${ACCOUNT_NO_PREFIX}\": {|" genesis.json

# Initialize validator
echo "Initializing validator..."
docker run --rm \
  -v $(pwd)/validator:/root/.ethereum \
  -v $(pwd)/genesis.json:/genesis.json \
  ethereum/client-go:v1.13.14 \
  init /genesis.json

# Initialize node1
echo "Initializing node1..."
docker run --rm \
  -v $(pwd)/node1:/root/.ethereum \
  -v $(pwd)/genesis.json:/genesis.json \
  ethereum/client-go:v1.13.14 \
  init /genesis.json

# Initialize node2
echo "Initializing node2..."
docker run --rm \
  -v $(pwd)/node2:/root/.ethereum \
  -v $(pwd)/genesis.json:/genesis.json \
  ethereum/client-go:v1.13.14 \
  init /genesis.json

# Start the validator
echo "Starting validator..."
docker run -d \
  --name geth-validator \
  --network ethereum \
  -v $(pwd)/validator:/root/.ethereum \
  -v $(pwd)/genesis.json:/genesis.json \
  -v $(pwd)/password.txt:/password.txt \
  -p 8545:8545 \
  -p 8546:8546 \
  -p 30303:30303 \
  ethereum/client-go:v1.13.14 \
  --networkid 1999 \
  --unlock "$ACCOUNT" \
  --password "/password.txt" \
  --mine \
  --miner.etherbase "$ACCOUNT" \
  --allow-insecure-unlock \
  --http \
  --http.addr '0.0.0.0' \
  --http.api 'eth,net,web3,miner,admin,personal,clique' \
  --http.corsdomain '*' \
  --ws \
  --ws.addr '0.0.0.0' \
  --ws.api 'eth,net,web3,miner,admin,personal,clique' \
  --ws.origins '*' \
  --nodiscover \
  --ipcdisable

# Start node1
echo "Starting node1..."
docker run -d \
  --name geth-node1 \
  --network ethereum \
  -v $(pwd)/node1:/root/.ethereum \
  -v $(pwd)/genesis.json:/genesis.json \
  -p 8547:8545 \
  -p 8548:8546 \
  -p 30304:30303 \
  ethereum/client-go:v1.13.14 \
  --networkid 1999 \
  --http \
  --http.addr '0.0.0.0' \
  --http.api 'eth,net,web3,admin,personal,clique' \
  --http.corsdomain '*' \
  --ws \
  --ws.addr '0.0.0.0' \
  --ws.api 'eth,net,web3,admin,personal,clique' \
  --ws.origins '*' \
  --nodiscover \
  --ipcdisable

# Start node2
echo "Starting node2..."
docker run -d \
  --name geth-node2 \
  --network ethereum \
  -v $(pwd)/node2:/root/.ethereum \
  -v $(pwd)/genesis.json:/genesis.json \
  -p 8549:8545 \
  -p 8550:8546 \
  -p 30305:30303 \
  ethereum/client-go:v1.13.14 \
  --networkid 1999 \
  --http \
  --http.addr '0.0.0.0' \
  --http.api 'eth,net,web3,admin,personal,clique' \
  --http.corsdomain '*' \
  --ws \
  --ws.addr '0.0.0.0' \
  --ws.api 'eth,net,web3,admin,personal,clique' \
  --ws.origins '*' \
  --nodiscover \
  --ipcdisable

echo "Network started!" 