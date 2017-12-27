contract Admin {

	address private _admin;

	function 	Admin( address admin ) public {
		_admin = admin;
	}

	function 	assertAdmin() private returns ( bool ) {
		if ( _admin != msg.sender )
			require( false );
		return true;
	}

	function 	setAdmin( address admin ) 	private returns ( bool ) {
		assertAdmin();
		_admin = admin;
		return true;
	}

	function 	getAdmin() public constant returns( address admin ) {
		return _admin;
	}
}