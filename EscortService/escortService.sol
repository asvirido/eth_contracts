pragma solidity ^0.4.18;

// contract Admin {

// 	address private _admin;

// 	function 	Admin( address admin ) public {
// 		_admin = admin;
// 	}

// 	function 	assertAdmin() private returns ( bool ) {
// 		if ( _admin != msg.sender )
// 			require( false );
// 		return true;
// 	}

// 	function 	setAdmin( address admin ) 	private returns ( bool ) {
// 		assertAdmin();
// 		_admin = admin;
// 		return true;
// 	}

// 	function 	getAdmin() public constant returns( address admin ) {
// 		return _admin;
// 	}
// }

// interface 	ERS20 {
// 	function 	transfer( address to, uint value ) public returns ( bool ok );
// 	function 	transferFrom( address from, address to, uint value) public returns ( bool ok );
// }


/*
function 	depositEth() payable public {
		
 		assertQuantity( msg.value );
		tokens[0][msg.sender] = safeAdd( tokens[0][msg.sender], msg.value );
		Deposit( 0, msg.sender, msg.value, tokens[0][msg.sender] );
 	}

	function 	withdrawEth( uint amount ) public {
		
		assertQuantity( amount );
		tokens[0][msg.sender] = safeSub( tokens[0][msg.sender], amount );
		msg.sender.transfer( amount );
		Withdraw( 0, msg.sender, amount, tokens[0][msg.sender] );
	}

	function 	depositToken( address token, uint amount ) public {

		assertToken( token );
		assertQuantity( amount );
		tokens[token][msg.sender] = safeAdd( tokens[token][msg.sender], amount );
		if ( Token( token ).transferFrom( msg.sender, this, amount ) == false ) {
			assert( false );
		}
		Deposit( token, msg.sender, amount , tokens[token][msg.sender] );
	}

	function 	withdrawToken( address token, uint amount ) public {
		
		assertToken( token );
		assertQuantity( amount );
		if ( Token( token ).transfer( msg.sender, amount ) == false ) {
			assert( false );
		}
		tokens[token][msg.sender] = safeSub( tokens[token][msg.sender], amount );
	    Withdraw( token, msg.sender, amount, tokens[token][msg.sender] );
	}
*/


// contract EscortService is Admin {

// 	address private 	_tokenEscort;

// 	mapping ( address => mapping (address => uint) ) private _balanceOf;

// 	function 	EscortService( address tokenEscort ) Admin(msg.sender) {
// 		_tokenEscort = tokenEscort;
// 	}
	
// }
