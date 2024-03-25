# Read bootnodes from JSON file
BOOTNODES=$(jq -r '.bootnodes | join(", ")' bootnodes.json)

# Start renloi with bootnodes from JSON file
renloi \
    --datadir ./rpc \
    --networkid 268 \
    --ws \
    --bootnodes="$BOOTNODES" \
    --ws.addr 127.0.0.1 \
    --ws.origins '*' \
    --ws.port 8545 \
    --http \
    --http.vhosts='*' \
    --http.port 800 \
    --rpc.txfeecap 0 \
    --http.corsdomain '*' \
    --nat 'any' \
    --http.api db,eth,net,web3,personal,txpool,miner,debug \
    --http.addr 127.0.0.1 \
    --http.vhosts=127.0.0.1 \
    --vmdebug \
    --pprof \
    --pprof.port 6060 \
    --pprof.addr 127.0.0.1 \
    --gcmode=archive \
    --syncmode=full \
    --ipcpath './rpc/renloi.ipc' \
    --snapshot=false \
    console
