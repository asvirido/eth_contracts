pragma solidity ^0.4.18;

import "browser/Admin.sol";
import "browser/DeadLine.sol";

interface 	token {
	function    transfer(address _to, uint256 _value) public returns (bool success);
	function    burn( uint256 value ) public returns ( bool success );
	function    balanceOf( address user ) public view returns ( uint256 );
}

contract 	WhiteList {
	address public _moderator;
	
	mapping ( address => bool ) internal _listAuthorizedUser;
	
	function 	WhiteList( address moderator ) public {
		_moderator = moderator;
	}

	function 	setAuthorizeUser( address user ) public {	
		assertModerator();

		_listAuthorizedUser[user] = true;
	}

	function 	getAuthorizeUser( address user ) public constant returns( bool ) {
		return 	_listAuthorizedUser[user];
	}

	function 	assertModerator() view internal {
		if ( msg.sender != _moderator )
			require( false );
	}

	function 	assertUser( address user ) view internal {
		if ( _listAuthorizedUser[user] == false )
			require( false );
	}
}

contract 	CrowdSale is Admin, WhiteList {
	address public 	_tokenReward;

	function 	CrowdSale( address tokenReward, address moderator ) public Admin( msg.sender ) WhiteList( moderator ) {
		_tokenReward = token(tokenReward);
	}

// 	function () public payable {
// 		// code
// 	}

// 	function    withdrawalMoneyBack() public {
// 		// code
// 	}

// 	function 	withdrawalAdmin() public {
// 		// code
// 	}

	function 	burnToken() private {
		uint 	amount;

		amount = _tokenReward.balanceOf( this );
		_tokenReward.burn( amount );
	}
}
