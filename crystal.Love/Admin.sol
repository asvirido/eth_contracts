pragma solidity ^0.4.18;

import "browser/IAdmin.sol";

contract Admin is IAdmin {

	address private _admin;

	function 	Admin( address admin ) public {
		_admin = admin;
	}

	function 	assertAdmin() private returns ( bool ) {
		if ( _admin != msg.sender )
			require( false );
		return true;
	}

	function 	getAdmin() public constant returns( address admin ) {
		return 	_admin;
	}
}
