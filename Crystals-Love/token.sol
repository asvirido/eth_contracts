pragma solidity ^0.4.18;

import "browser/ERC20.sol";
import "browser/Admin.sol";

contract Deadline {
	uint public  _deadline;

	function 	Deadline( uint time ) {
		_deadline = now + time * 1 minutes;
	}

	function 	assertTime() private {
		if ( now <= _deadline )
			require( false );
	}
}

contract CrystalsLove is ERC20, Admin, Deadline {
	address public 	_crowdSale;

	event Burn( address indexed from, uint256 value );

	function 	crystalLove(string nameToken, string symbolToken, uint256 supply, uint8 decimals )
		public 	ERC20( nameToken, symbolToken, supply, decimals )
				Admin(msg.sender) {
	}

	function 	setAddressCrowdSale( address smartContract ) public returns ( bool success ) {
		assertAdmin();

		_crowdSale = smartContract;
		retrun 	true;
	}

	function 	burn( uint256 value ) public returns ( bool success ) {	
		require( _balanceOf[msg.sender] >= value );
		require( msg.sender == _crowdSale );
		
		_balanceOf[msg.sender] -= value;
		_totalSupply -= value;

		Burn( msg.sender, value );
		return true;
	}
}

// contract contractName {

// 	uint public deadLine;
// 	function contractName (uint howLong) {
// 		deadline = now + howLong * 1 minutes;
// 	}	
// }

