#!/bin/bash


### Constants and Environment Variables

# Set-up Constants
DEFAULT_PWD_FILE="./data/default-password.txt"
GENESIS_PATH="./data/genesis.json"

# Sender and Receiver
SENDER_DIR="./data/client1"
SENDER_HTTP_PORT=8000
SENDER_PORT=30303
RECEIVER_DIR="./data/client2"
RECEIVER_HTTP_PORT=8001
RECEIVER_PORT=30304

# SDX Constants
SDX_NET_ID=18930236
SDX_NAT_TYPE="any"

# Boot Info
BOOT_IP='3.141.232.198' # Public
SDX_BOOT_ENODE="enode://ffb143c241fec6cde474e28106d162ae5107e2d0ab322b27d71ec32567a650c1077bbdefc4951efbcb400de02ff86621c49b7d0d4dfdecc7862f979942a43c5e@${BOOT_IP}:30303"


### Main Execution

# Initialize Node with Genesis Block
if [ ! -d "${NODE_DIR}/geth" ]
then
  echo "Syncing Node with Genesis Block"
  geth --datadir ${NODE_DIR} init ${GENESIS_PATH}
fi

# Start-Up Sender
geth --datadir ${SENDER_DIR} \
	--http \
	--http.port ${SENDER_HTTP_PORT} \
	--http.api "eth,net,web3,personal,miner,admin" \
	--http.corsdomain "*" \
	--port ${SENDER_PORT} \
	--networkid ${SDX_NET_ID} \
	--nat "${SDX_NAT_TYPE}" \
  --allow-insecure-unlock \
  --bootnodes "${SDX_BOOT_ENODE}" &

# Start-Up Receiver
geth --datadir ${RECEIVER_DIR} \
	--http \
	--http.port ${RECEIVER_HTTP_PORT} \
	--http.api "eth,net,web3,personal,miner,admin" \
	--http.corsdomain "*" \
	--port ${RECEIVER_PORT} \
	--networkid ${SDX_NET_ID} \
	--nat "${SDX_NAT_TYPE}" \
  --allow-insecure-unlock \
  --bootnodes "${SDX_BOOT_ENODE}"
