
contract Admin {

	address public 	_admin;

	function 	Admin() public {
		_admin = msg.sender;
	}

	function 	assertAdmin() private returns ( bool ) {
		if ( _admin != msg.sender )
			require( false );
	}
}
