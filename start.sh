#!/bin/bash
set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

totalRpc=0
totalValidator=0
totalNodes=0
isRPC=false
isValidator=false

source ./.env

welcome(){
    echo -e "\n\n\t${ORANGE}Total RPC installed: $totalRpc"
    echo -e "\t${ORANGE}Total Validators installed: $totalValidator"
    echo -e "\t${ORANGE}Total nodes installed: $totalNodes"
    echo -e "${GREEN}\t+------------------------------------------------+\n\t+   Renloi node Execution Utility\n\t+   Your OS: $(. /etc/os-release && printf '%s\n' "${PRETTY_NAME}")\n\t+   example usage: ./start.sh --help\n\t+------------------------------------------------+${NC}\n\n${ORANGE}\t+------------------------------------------------+\n\t+------------------------------------------------+${NC}"
}

countNodes(){
    i=1
    totalNodes=$(ls -l ./chaindata/ | grep -c ^d)
    while [[ $i -le $totalNodes ]]; do
        if [ -f "./chaindata/node$i/.rpc" ]; then
            ((totalRpc += 1))
        else
            if [ -f "./chaindata/node$i/.validator" ]; then
                ((totalValidator += 1))
            fi
        fi
        ((i += 1))
    done
}

startRpc(){
    i=$((totalValidator + 1))
    while [[ $i -le $totalNodes ]]; do
        if tmux has-session -t node$i > /dev/null 2>&1; then
            :
        else
            tmux new-session -d -s node$i
            tmux send-keys -t node$i " ./node_src/build/bin/geth --datadir ./chaindata/node$i --networkid 268 --ws --ws.addr $IP --ws.origins '*' --ws.port 8545 --http --http.port 80 --rpc.txfeecap 0  --http.corsdomain '*' --nat 'any' --http.api db,eth,net,web3,personal,txpool,miner,debug --http.addr $IP --http.vhosts=$VHOST --vmdebug --pprof --pprof.port 6060 --pprof.addr $IP --gcmode=archive --syncmode=full --ipcpath './chaindata/node$i/geth.ipc' console" Enter
        fi
        ((i += 1))
    done
}

startValidator(){
    i=1
    j=69
    while [[ $i -le $totalValidator ]]; do
        if tmux has-session -t node$i > /dev/null 2>&1; then
            :
        else
            tmux new-session -d -s node$i
            tmux send-keys -t 0 "./node_src/build/bin/geth --datadir ./chaindata/node$i --networkid 268 --bootnodes $BOOTNODE --mine --port 326$j --nat extip:$IP --gpo.percentile 0 --gpo.maxprice 100 --gpo.ignoreprice 0 --unlock 0 --password ./chaindata/node$i/pass.txt --syncmode=full console" Enter
        fi
        ((i += 1))
        ((j += 1))
    done
}

finalize(){
    countNodes
    welcome
    if [ "$isRPC" = true ]; then
        echo -e "\n${GREEN}+------------------- Starting RPC -------------------+"
        startRpc
    fi
    if [ "$isValidator" = true ]; then
        echo -e "\n${GREEN}+------------------- Starting Validator -------------------+"
        startValidator
    fi
    echo -e "\n${GREEN}+------------------ Active Nodes -------------------+"
    tmux ls
    echo -e "\n${GREEN}+------------------ Active Nodes -------------------+${NC}"
}

verbose_mode=false
output_file=""

usage() {
    echo -e "\nUsage: $0 [OPTIONS]"
    echo "Options:"
    echo -e "\t\t -h, --help      Display this help message"
    echo -e " \t\t -v, --verbose   Enable verbose mode"
    echo -e "\t\t --rpc       Start all the RPC nodes installed"
    echo -e "\t\t --validator       Start all the Validator nodes installed"
}

has_argument() {
    [[ ("$1" == *=* && -n ${1#*=}) || (! -z "$2" && "$2" != -*) ]]
}

extract_argument() {
    echo "${2:-${1#*=}}"
}

handle_options() {
    while [ $# -gt 0 ]; do
        case $1 in
        -h | --help)
            usage
            exit 0
            ;;
        -v | --verbose)
            verbose_mode=true
            ;;
        --rpc)
            isRPC=true
            ;;
        --validator)
            isValidator=true
            ;;
        *)
            echo "Invalid option: $1" >&2
            usage
            exit 1
            ;;
        esac
        shift
    done
}

handle_options "$@"

if [ "$verbose_mode" = true ]; then
    echo "Verbose mode enabled."
fi

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    usage
    exit 1
fi

finalize
