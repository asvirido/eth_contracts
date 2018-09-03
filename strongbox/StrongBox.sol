pragma solidity ^0.4.18;

contract Token {
	function transfer( address _to, uint256 _value ) public returns ( bool success );
	function transferFrom( address _from, address _to, uint256 _value ) public returns ( bool success );
}

contract SafeMath {
	function safeAdd( uint a, uint b ) internal pure returns ( uint ) {
		uint 	c;

		c = a + b;
		assert( c >= a && c >= b );
		return c;
	}
}

contract StrongBox is SafeMath {
	mapping ( bytes32 => mapping ( address => uint ) ) public _tokens;
	

	function () public payable {
		require( false );
	}
	
	function 	depositEth( bytes32 hash ) public payable {
		assertQuantity( msg.value );
		_tokens[hash][0] = safeAdd( _tokens[hash][0], msg.value );
	}

	function 	withdrawEth( string key ) public {
		bytes32 	hash;
		uint		amount;

		hash = sha256( key );
		amount = _tokens[hash][0];
		assertQuantity( amount );
		_tokens[hash][0] = 0;
		msg.sender.transfer( amount );
	}

	function 	depositToken( bytes32 hash, address token, uint amount ) public {
		assertQuantity( amount );
		assertToken( token );
		_tokens[hash][token] = safeAdd( _tokens[hash][token], amount );
		if ( Token( token ).transferFrom( msg.sender, this, amount ) == false ) {
			assert( false );
		}
	}

	function 	withdrawToken( string key, address token ) public {
		uint 		amount;
		bytes32		hash;

		assertToken( token );
		hash = sha256( key );
		amount = _tokens[hash][token];
		assertQuantity(amount);
		_tokens[hash][token] = 0;
		if ( Token( token ).transfer( msg.sender, amount ) == false ) {
			assert( false );
		}
	}

	function	transferBox( string keyTo, address token, bytes32 from ) public {
		uint 		amount;
		bytes32		hash;

		hash = sha256( keyTo );
		assertDoubleHash(hash, from);
		amount = _tokens[hash][token];
		assertQuantity( amount );
		_tokens[hash][token] = 0;
		_tokens[from][token] = safeAdd( _tokens[from][token], amount );
	}

	function 	assertQuantity( uint amount ) private pure {
		if ( amount == 0 ) {
			require( false );
		}
	}
	function 	assertDoubleHash( bytes32 a, bytes32 b) private pure {
		if ( a == b ) {
			require( false );
		}
	}
	function 	assertToken( address token ) private pure {
		if ( token == 0 ) {
			require( false );
		}
	}
}
