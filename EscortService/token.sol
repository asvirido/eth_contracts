pragma solidity ^0.4.18;

import "interface/ERC20.sol";
import "interface/Admin";

contract crystalLove is ERC20 {
	function crystalLove (string nameToken, string symbolToken, uint256 supply, uint8 decimals) {
		baseToken( nameToken, symbolToken, supply, decimals );
	}
}
