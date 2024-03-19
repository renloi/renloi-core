#!/bin/bash
set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m'
totalRpc=0
totalvalidators=0
totalNodes=$(($totalRpc + $totalvalidators))

task1(){
  # update and upgrade the server TASK 1
  echo -e "\n\n${ORANGE}TASK: ${GREEN}[Setting up environment]${NC}\n"
  apt update && apt upgrade -y
  echo -e "\n${GREEN}[TASK 1 PASSED]${NC}\n"
}

task2(){
  # installing build-essential TASK 2
  echo -e "\n${ORANGE}TASK: ${GREEN}[Setting up environment]${NC}\n"
  apt -y install build-essential tree
  echo -e "\n${GREEN}[TASK 2 PASSED]${NC}\n"
}

task3(){
  # getting golang TASK 3
  echo -e "\n${ORANGE}TASK: ${GREEN}[Getting GO]${NC}\n"
  mkdir tmp && mkdir chaindata
  cd ./tmp && wget "https://go.dev/dl/go1.22.1.linux-amd64.tar.gz"
  echo -e "\n${GREEN}[TASK 3 PASSED]${NC}\n"
}

task4(){
  # setting up golang TASK 4
  echo -e "\n${ORANGE}TASK: ${GREEN}[Setting GO]${NC}\n"
  rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz
  echo -e '\nPATH=$PATH:/usr/local/go/bin' >>/etc/profile
  export PATH=$PATH:/usr/local/go/bin
  go env -w GO111MODULE=off
  echo -e "\n${GREEN}[TASK 4 PASSED]${NC}\n"
}

task5(){
  # set proper group and permissions TASK 5
  echo -e "\n${ORANGE}TASK: ${GREEN}[Setting up Permissions]${NC}\n"
  ls -all
  cd ../
  ls -all
  chown -R root:root ./
  echo -e "\n${GREEN}[TASK 5 PASSED]${NC}\n"
}

task6(){
  # do make all TASK 6
  echo -e "\n${ORANGE}TASK: ${GREEN}[Building Backend]${NC}\n"
  make all
  mv build/bin/renloi /usr/bin/renloi
  echo -e "\n${GREEN}[TASK 6 PASSED]${NC}\n"
}

task7(){
  # setting up directories and structure for node/s TASK 7
  echo -e "\n${ORANGE}TASK: ${GREEN}[Building Backend]${NC}\n"

  i=1
  while [[ $i -le $totalNodes ]]; do
    mkdir -p chaindata/node$i
    ((i += 1))
  done

  tree chaindata
  echo -e "\n${GREEN}[TASK 7 PASSED]${NC}\n"
}

task8(){
  #TASK 8
  echo -e "\n${ORANGE}TASK: ${GREEN}[Setting up Accounts]${NC}\n"
  echo -e "\n${ORANGE}This step is very important. Input a password that will be used for a newly created validators account. In the next step, you can choose to create a new account or import an existing one.\n\n${NC}"

  i=1
  while [[ $i -le $totalvalidators ]]; do
    echo -e "\n\n${GREEN}+-----------------------------------------------------------------------------------------------------+\n"
    read -p "Enter password for validators $i:  " password
    echo $password >chaindata/node$i/pass.txt

    # Prompt user whether to import or create new account
    read -p "Do you want to import an existing validator account? (y/n): " import_choice
    if [ "$import_choice" == "y" ]; then
      read -p "Paste the hex string to import the validator account: " hex_string
      # Run import command
      renloi account import --datadir ./chaindata/node$i --password ./chaindata/node$i/pass.txt <(echo "$hex_string")
    else
      # Create a new account
      renloi --datadir chaindata/node$i account new --password chaindata/node$i/pass.txt
    fi

    ((i += 1))
  done

  echo -e "\n${GREEN}[TASK 8 PASSED]${NC}\n"
}


labelNodes(){
  i=1
  while [[ $i -le $totalvalidators ]]; do
    touch chaindata/node$i/.validators
    ((i += 1))
  done 

  i=$((totalvalidators + 1))
  while [[ $i -le $totalNodes ]]; do
    touch chaindata/node$i/.rpc
    ((i += 1))
  done 
}

displayStatus(){
  # start the node
  echo -e "\n${ORANGE}STATUS: ${GREEN}ALL TASK PASSED!\n This program will now exit\n"
}

displayWelcome(){
  # display welcome message
  echo -e "\n\n\t${ORANGE}Total RPC to be created: $totalRpc"
  echo -e "\t${ORANGE}Total validators to be created: $totalvalidators"
  echo -e "\t${ORANGE}Total nodes to be created: $totalNodes"
  echo -e "${GREEN}
  \t+------------------------------------------------+
  \t+   Renloi node installation Wizard
  \t+   Target OS: Ubuntu 20.04 LTS (Focal Fossa)
  \t+   Your OS: $(. /etc/os-release && printf '%s\n' "${PRETTY_NAME}") 
  \t+------------------------------------------------+
  ${NC}\n"

  echo -e "${ORANGE}
  \t+------------------------------------------------+
  \t+------------------------------------------------+
  ${NC}"
}

doUpdate(){
  echo -e "${GREEN}
  \t+------------------------------------------------+
  \t+       UPDATING TO LATEST    
  \t+------------------------------------------------+
  ${NC}"
  git pull
}

createRpc(){
  task1
  task2
  task3
  task4
  task5
  task6
  task7
  i=$((totalvalidators + 1))
  while [[ $i -le $totalNodes ]]; do
    read -p "Enter Virtual Host(example: rpc.yourdomain.tld) without https/http: " vhost
    echo -e "\nVHOST=$vhost" >> ./.env
    renloi --datadir chaindata/node$i init genesis.json
    ((i += 1))
  done
}

createvalidators(){
  if [[ $totalvalidators -gt 0 ]]; then
      task8
  fi
   i=1
  while [[ $i -le $totalvalidators ]]; do
    renloi --datadir chaindata/node$i init genesis.json
    ((i += 1))
  done
}

# get external IP of this server
fetchNsetIP(){
  echo -e "\nIP=$(curl http://checkip.amazonaws.com)" >> ./.env
}

finalize(){
  displayWelcome
  createRpc
  createvalidators
  labelNodes
  fetchNsetIP
  displayStatus
}

# Default variable values
verbose_mode=false
output_file=""

# Function to display script usage
usage() {
  echo -e "\nUsage: $0 [OPTIONS]"
  echo "Options:"
  echo -e "\t\t -h, --help      Display this help message"
  echo -e " \t\t -v, --verbose   Enable verbose mode"
  echo -e "\t\t --rpc      Specify to create RPC node"
  echo -e "\t\t --validators  <number>     Specify how many validators node to create"
}

has_argument() {
  [[ ("$1" == *=* && -n ${1#*=}) || (! -z "$2" && "$2" != -*) ]]
}

extract_argument() {
  echo "${2:-${1#*=}}"
}

# Function to handle options and arguments
handle_options() {
  while [ $# -gt 0 ]; do
    case $1 in

    # display help
    -h | --help)
      usage
      exit 0
      ;;

    # toggle verbose
    -v | --verbose)
      verbose_mode=true
      ;;

    # take file input
    -f | --file*)
      if ! has_argument $@; then
        echo "File not specified." >&2
        usage
        exit 1
      fi

      output_file=$(extract_argument $@)

      shift
      ;;

    # take ROC count
    --rpc)
      totalRpc=1
      totalNodes=$(($totalRpc + $totalvalidators))
      ;;

    # take validators count
    --validators*)
      if ! has_argument $@; then
        echo "No number given" >&2
        usage
        exit 1
      fi
      totalvalidators=$(extract_argument $@)
      totalNodes=$(($totalRpc + $totalvalidators))
      shift
      ;;

      # check for update and do update
      --update)
      doUpdate
      exit 0
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

# Main script execution
handle_options "$@"

# Perform the desired actions based on the provided flags and arguments
if [ "$verbose_mode" = true ]; then
  echo "Verbose mode enabled."
fi

if [ -n "$output_file" ]; then
  echo "Output file specified: $output_file"
fi

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    usage
    exit 1
fi


# bootstraping
finalize
