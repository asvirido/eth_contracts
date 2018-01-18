pragma solidity ^0.4.18;

import "browser/ERC20.sol";
import "browser/Admin.sol";

contract crystalLove is ERC20, Admin {
	function crystalLove (string nameToken, string symbolToken, uint256 supply, uint8 decimals)
		public 	ERC20( nameToken, symbolToken, supply, decimals )
				Admin(msg.sender) {
	}
}
