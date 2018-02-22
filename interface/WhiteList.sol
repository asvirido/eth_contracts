pragma solidity ^0.4.18;

contract Admin {

	address private _admin;

	function 	Admin( address admin ) public {
		_admin = admin;
	}

	function 	assertAdmin() internal view returns ( bool ) {
		if ( _admin != msg.sender )
			require( false );
		return true;
	}

	function 	getAdmin() public constant returns( address admin ) {
		return 	_admin;
	}
}

contract 	WhiteList is Admin {
	mapping ( address => bool ) internal _moderator;
	mapping ( address => bool ) internal _listAuthorizedUser;

	/* + */
	function 	WhiteList( address admin ) public Admin( admin ) { }
	/* + */
	function 	setAuthorizeUser( address user ) public {
		assertModerator();
		_listAuthorizedUser[user] = true;
	}
	/* + */
	function 	addModerator( address userModerator ) public {
		assertAdmin();
		_moderator[userModerator] = true;
	}
	/* + */
	function 	deleteModerator( address userModerator ) public {
		assertAdmin();
		_moderator[userModerator] = false;
	}
	/* + */
	function 	getAuthorizeUser( address user ) public constant returns( bool ) {
		return 	_listAuthorizedUser[user];
	}
	/* + */
	function 	getModerator( address user ) public constant returns( bool ) {
		return 	_moderator[user];
	}
	/* + */
	function 	assertModerator() view internal {
		if ( _moderator[msg.sender] == false )
			require( false );
	}
	/* + */
	function 	assertUserAuthorized( address user ) view internal {
		if ( _listAuthorizedUser[user] == false )
			require( false );
	}
}
