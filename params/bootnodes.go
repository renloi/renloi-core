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
	"enode://ca7a1f191c9d34117d2f03d8298e3465da68a91a6bef701a6e5aef6ea64290ffe80aa0f893ae3b1b908ef10db2fdd1eeafa8bb713da2ce21337319cc2b86b593@64.226.81.152:32668",
}

var V5Bootnodes = []string{}

// KnownDNSNetwork returns the address of a public DNS-based node list for the given
// genesis hash and protocol. See https://github.com/ethereum/discv4-dns-lists for more
// information.
func KnownDNSNetwork(genesis common.Hash, protocol string) string {
	return ""
}
