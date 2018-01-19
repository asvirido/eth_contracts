pragma solidity ^0.4.18;

import "browser/ERC20.sol";
import "browser/Admin.sol";

contract DeadLine {
	uint public  _deadline;

	function 	DeadLine( uint time ) public {
		_deadline = now + time * 1 minutes;
	}

	function 	assertTime() view private {
		if ( now <= _deadline )
			require( false );
	}
}

contract CrystalsLove is ERC20, Admin, DeadLine {
	address public 	_crowdSale;
	bool	public 	_editEnd;

	event 	Burn( address indexed from, uint256 value );
	event 	Freeze( address admin, uint time, uint amount );
	
	function 	CrystalsLove( string nameToken, string symbolToken, uint256 supply, uint8 decimals, uint time)
		public 	ERC20( nameToken, symbolToken, supply, decimals )
		        Admin( msg.sender ) DeadLine( time ) {
	}

	function 	setAddressCrowdSale( address smartContract ) public returns ( bool ) {
		assertAdmin();
		require( _editEnd == false);

		_crowdSale = smartContract;
		_editEnd = true;
		return 	true;
	}

	function 	burn( uint256 value ) public returns ( bool ) {	
		require( _balanceOf[msg.sender] >= value );
		require( msg.sender == _crowdSale );
		
		_balanceOf[msg.sender] -= value;
		_totalSupply -= value;

		Burn( msg.sender, value );
		return true;
	}

	function 	freezen( uint time, uint amount )  public returns ( bool ) {
		assertAdmin();

		if ( _balanceOf[getAdmin()] <= amount ) {
			require( false );
		}
		_balanceOf[getAdmin()] -= amount;
		_balanceOf[0] += amount;
		
		Freeze( getAdmin(), time, amount );
		return 	true;
	}
}

// contract contractName {

// 	uint public deadLine;
// 	function contractName (uint howLong) {
// 		deadline = now + howLong * 1 minutes;
// 	}	
// }

