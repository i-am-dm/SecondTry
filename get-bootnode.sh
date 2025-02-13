#!/bin/bash

# Wait for node1 to start and get its enode URL
while ! docker-compose exec -T node1 geth --exec "admin.nodeInfo.enode" attach /root/geth.ipc > node1/bootnode.txt 2>/dev/null
do
    echo "Waiting for node1 to start..."
    sleep 2
done

# Copy the bootnode information to other nodes
cp node1/bootnode.txt node2/bootnode.txt
cp node1/bootnode.txt node3/bootnode.txt
cp node1/bootnode.txt node4/bootnode.txt

echo "Bootnode information has been distributed to all nodes" 