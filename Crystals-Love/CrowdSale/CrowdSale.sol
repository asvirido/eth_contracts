pragma solidity ^0.4.18;

import "browser/Admin.sol";
import "browser/DeadLine.sol";

interface 	token {
	function    transfer(address _to, uint256 _value) public returns (bool success);
	function    burn( uint256 value ) public returns ( bool success );
	function    balanceOf( address user ) public view returns ( uint256 );
}

contract 	WhiteList {
	address public	_moderator;
	
	mapping ( address => bool ) internal _listAuthorizedUser;
	
	function 	WhiteList( address moderator ) public {
		_moderator = moderator;
	}
	// need test
	function 	setAuthorizeUser( address user ) public {	
		assertModerator();

		_listAuthorizedUser[user] = true;
	}
	// need test
	function 	getAuthorizeUser( address user ) public constant returns( bool ) {
		return 	_listAuthorizedUser[user];
	}
	// need test
	function 	assertModerator() view internal {
		if ( msg.sender != _moderator )
			require( false );
	}
	// need test
	function 	assertUser( address user ) view internal {
		if ( _listAuthorizedUser[user] == false )
			require( false );
	}
}

contract 	CrowdSale is Admin, WhiteList {
	token 	public 	_tokenReward;
	uint 	public	_price;
	uint 	public	_amountRaised;
    bool    public 	_crowdSaleClosed;
    bool    public 	_crowdSaleSuccess;

	mapping( address => uint ) public 	_balanceOf;

	function 	CrowdSale( address addressOfTokenUsedAsReward, address moderator, uint price )
		public 	Admin( msg.sender ) WhiteList( moderator ) {
		_tokenRe1ward = token( addressOfTokenUsedAsReward );
		_price = price;
	}

	function () public payable {
		assertClosed();
		// code
	}

// 	function    withdrawalMoneyBack() public {
// 		// code
// 	}

// 	function 	withdrawalAdmin() public {
// 		// code
// 	}
	// need test
	function 	burnToken() private {
		uint 	amount;

		amount = _tokenReward.balanceOf( this );
		_tokenReward.burn( amount );
	}
	// need test
	function 	assertClosed() view private {
		if ( _crowdSaleClosed == false ) {
			require( false );
		}
	}
	// need test
	function 	assertSuccess() view private {
		if ( _crowdSaleSuccess == false ) {
			require( false );
		}
	}
}
