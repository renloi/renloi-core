package systemcontract

import (
	"github.com/renloi/renloi-core/accounts/abi"
	"github.com/renloi/renloi-core/common"
	"github.com/renloi/renloi-core/params"
	"math/big"
)

var (
	ValidatorsContractName   = "validators"
	PunishContractName       = "punish"
	ValidatorsContractAddr   = common.HexToAddress("0x0000000000000000000000000000000000000001")
	PunishContractAddr       = common.HexToAddress("0x0000000000000000000000000000000000000002")

	abiMap map[string]abi.ABI
)

func GetInteractiveABI() map[string]abi.ABI {
	return abiMap
}

func GetValidatorAddr(blockNum *big.Int, config *params.ChainConfig) *common.Address {
	if config.IsRedCoast(blockNum) {
		return &ValidatorsContractAddr
	}
	return &ValidatorsContractAddr
}

func GetPunishAddr(blockNum *big.Int, config *params.ChainConfig) *common.Address {
	if config.IsRedCoast(blockNum) {
		return &PunishContractAddr
	}
	return &PunishContractAddr
}