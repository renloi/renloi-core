# Renloi Core

Welcome to the Renloi Core repository, the heart of our blockchain node implementation. Renloi Core forms the backbone of our decentralized network, embodying the principles of delegated proof of stake (DPoS) consensus. It leverages Renloi's bespoke implementation of go-ethereum and meticulously designed system contracts available [here](https://github.com/renloi/renloi-contracts). We are dedicated to providing users with multiple release candidates to ensure access to cutting-edge features and robust stability.

## Acknowledgements

Renloi Core owes its existence to the groundbreaking work of the heco-chain project by stars-lab, which itself stands on the shoulders of the Ethereum Foundation's foundational contributions. We extend our gratitude to the following projects for their invaluable contributions:

- [go-ethereum](https://github.com/ethereum/go-ethereum)
- [heco-chain](https://github.com/stars-labs/heco-chain)

The innovations catalyzed by Bitcoin and further advanced by the Ethereum Foundation have paved the way for a plethora of technological advancements and applications. We actively participate in and advocate for decentralization initiatives and their derivatives.

## Security Measures
Renloi Core prioritizes security and has implemented the latest fixes from go-ethereum up to version v1.10.13. These updates include comprehensive security enhancements such as code audits, bug fixes, and protocol upgrades. We are committed to maintaining a robust security posture to safeguard our users' assets and ensure the integrity of our decentralized network.

## System Requirements

Ensure your system meets the following prerequisites for optimal Renloi Core performance:

- **CPU:** x86_64 architecture is recommended. While other architectures supported by the go compiler may function, they have not been extensively tested.
- **OS:** Any Debian-based system is suitable, with Ubuntu version 20.04 LTS or later being recommended for optimal compatibility and stability.
- **RAM:** A minimum of 4GB is required, but we recommend 16GB for smoother operation.
- **Storage:** At least 128GB of storage space is necessary, with 512GB recommended for efficient data management.

## Installation

To install Renloi Core on Ubuntu, follow these steps:

1. Ensure your system is up to date and equipped with necessary tools:
```bash
sudo su
apt update && apt upgrade -y && apt-get install git wget curl tar
```

2. Clone the Renloi Core repository and initiate the bootstrap process:
```bash
git clone https://github.com/renloi/renloi-core
cd renloi-core
chmod 755 setup.sh
./setup.sh
```
