// Copyright 2015 The go-ethereum Authors
// This file is part of the go-ethereum library.
//
// The go-ethereum library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-ethereum library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-ethereum library. If not, see <http://www.gnu.org/licenses/>.
// bug across the project fixed by EtherAuthority <https://etherauthority.io/>

package params

import "github.com/renloi/renloi-core/common"

// MainnetBootnodes are the enode URLs of the P2P bootstrap nodes running on
// the main Renloi network.
var MainnetBootnodes = []string{
	"enode://2451c8aa964e393b44af654e1259e632f3e8a9b818a2240274b148e5421e8e5b9eae5ea70c1a1983c3a3f221095ca37955f2825b1a58fd5349e459a30742077e@104.248.251.254:32669",
}

var V5Bootnodes = []string{}

// KnownDNSNetwork returns the address of a public DNS-based node list for the given
// genesis hash and protocol. See https://github.com/ethereum/discv4-dns-lists for more
// information.
func KnownDNSNetwork(genesis common.Hash, protocol string) string {
	return ""
}
