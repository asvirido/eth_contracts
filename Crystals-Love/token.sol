pragma solidity ^0.4.18;

import "browser/ERC20.sol";
import "browser/Admin.sol";

contract DeadLine {
	uint public  _deadline;

	function 	DeadLine( uint time ) {
		_deadline = now + time * 1 minutes;
	}

	function 	assertTime() private {
		if ( now <= _deadline )
			require( false );
	}
}

contract CrystalsLove is ERC20, Admin, DeadLine {
	address public 	_crowdSale;

	event 	Burn( address indexed from, uint256 value );
	event 	Freeze( address admin, uint time, uint amount );
	
	function 	crystalLove( string nameToken, string symbolToken, uint256 supply, uint8 decimals )
		public 	ERC20( nameToken, symbolToken, supply, decimals ) Admin( msg.sender ) {
	}

	function 	setAddressCrowdSale( address smartContract ) public returns ( bool ) {
		assertAdmin();

		_crowdSale = smartContract;
		retrun 	true;
	}

	function 	burn( uint256 value ) public returns ( bool ) {	
		require( _balanceOf[msg.sender] >= value );
		require( msg.sender == _crowdSale );
		
		_balanceOf[msg.sender] -= value;
		_totalSupply -= value;

		Burn( msg.sender, value );
		return true;
	}

	function 	freezen( uint time, uint amount ) DeadLine( time ) public returns ( bool ) {
		assertAdmin();

		// amount *= decimals; this is need check
		if ( _balanceOf[_admin] <= amount ) {
			require( false );
		}
		_balanceOf[_admin] -= amount;
		_balanceOf[0] += amount;
		
		Freeze( admin, time, amount );
		return 	true;
	}
}

// contract contractName {

// 	uint public deadLine;
// 	function contractName (uint howLong) {
// 		deadline = now + howLong * 1 minutes;
// 	}	
// }

