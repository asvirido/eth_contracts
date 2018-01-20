pragma solidity ^0.4.18;

import "browser/Admin.sol";
import "browser/DeadLine";

interface 	token {
    function    transfer(address _to, uint256 _value) public returns (bool success);
    function    burn( uint256 value ) public returns ( bool success );
    function    balanceOf( address user ) public view returns ( uint256 );
}

contract CrowdSale is Admin, DeadLine {
	address public 	_tokenReward;

	function 	CrowdSale( address tokenReward ) public {
		_tokenReward = tokenReward;
	}

	function () public payable {
		// code
	}

	function    withdrawalMoneyBack() public {
		// code
	}

	function 	withdrawalAdmin() public {
		// code
	}

	function 	burnToken() private {
		uint 	amount;

		amount = tokenReward.balanceOf(this);
		tokenReward.burn(amount);
	}
}
