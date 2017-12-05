pragma solidity ^0.4.16;

contract SafeMath {

	function safeMul( uint a, uint b ) internal returns ( uint ) {
		
		uint c;
		
		c = a * b;
		assert( a == 0 || c / a == b );
		return c;
	}

	function safeSub( uint a, uint b ) internal returns ( uint ) {
		
		assert( b <= a );
		return a - b;
	}

	function safeAdd( uint a, uint b ) internal returns ( uint ) {
		
		uint c;
	
		c = a + b;
		assert( c >= a && c >= b );
		return c;
	}
}

contract Token {

	function totalSupply() public constant returns ( uint256 supply );
	
	function balanceOf( address _owner ) public constant returns ( uint256 balance );
	
	function transfer( address _to, uint256 _value ) public returns ( bool success );
	
	function transferFrom( address _from, address _to, uint256 _value ) public returns ( bool success );
	
	function approve( address _spender, uint256 _value ) public returns ( bool success );

	function allowance( address _owner, address _spender ) public constant returns ( uint256 remaining );
	
	event Transfer( address indexed _from, address indexed _to, uint256 _value );

	event Approval( address indexed _owner, address indexed _spender, uint256 _value );
}

contract Admin {

	address public	admin;
	address public	feeAccount;
	address public 	nextVersionAddress;
	bool 	public	orderEnd;
	// add variable version;
	uint 	public	feeTake; //percentage times (1 ether)

	function Admin( address _admin, address _feeAccount, uint _feeTake) public {
		
		admin = _admin;
		feeAccount = _feeAccount;
		feeTake = _feeTake;
		orderEnd = true;
	}

	modifier assertAdmin() {
		
		if ( msg.sender != admin ) {
			require( false );
		}
		_;
	}

	function setAdmin( address _admin ) assertAdmin public {
		
		admin = _admin;
	}

	function setNextVersionAddress(address _nextVersionAddress) assertAdmin public{
		
		nextVersionAddress = _nextVersionAddress;	
	}

	function setOrderEnd() assertAdmin public {
		
		orderEnd = false;
	}

	function setFeeAccount( address _feeAccount ) assertAdmin public {
		
		feeAccount = _feeAccount;
	}

	function setFeeTake( uint _feeTake ) assertAdmin public {
		
		if ( _feeTake > feeTake )
			assert( false );
		feeTake = _feeTake;
	}
	
}

contract Exchange is SafeMath, Admin {

    mapping( address => mapping( address => uint )) public tokens;
    mapping( address => mapping( bytes32 => bool )) public orders;
    mapping( address => mapping( bytes32 => uint )) public orderFills;

    event Deposit( address token, address user, uint amount, uint balance );
    event Withdraw( address token, address user, uint amount, uint balance );
    event Order( address user, address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, uint nonce );
    event OrderCancel( address user, address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, uint nonce );
    event Trade( address userBuy, address userSell, address tokenBuy, address tokenSell, uint amountBuy, uint amountSell );

    function assertQuantity( uint amount ) private {
        
		if ( amount == 0 ) {
            assert( false );
        }
    }

	function assertToken( address token ) private { 
		
		if ( token == 0 ) {
			assert( false );
		}
	}

 	function 	depositEth() payable public {
		
 		assertQuantity( msg.value );
		tokens[0][msg.sender] = safeAdd( tokens[0][msg.sender], msg.value );
		Deposit( 0, msg.sender, msg.value, tokens[0][msg.sender] );
 	}

    function 	withdrawEth( uint amount ) public {
		
		assertQuantity( amount );
		if ( msg.sender.call.value( amount )() == false ) {
			assert( false );
		}
		tokens[0][msg.sender] = safeSub( tokens[0][msg.sender], amount );
		Withdraw( 0, msg.sender, amount, tokens[0][msg.sender] );
	}

	function 	depositToken( address token, uint amount ) public {

		assertToken( token );
		assertQuantity( amount );
		if ( Token( token ).transferFrom( msg.sender, this, amount ) == false ) {
			assert( false );
		}
		tokens[token][msg.sender] = safeAdd( tokens[token][msg.sender], amount );
		Deposit( token, msg.sender, amount, tokens[token][msg.sender] );
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
	
	function 	order( address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, uint nonce ) public {

		bytes32 	hash;

		assertQuantity( amountBuy );
		assertQuantity( amountSell );
		if ( orderEnd == false )
			assert( false );

		hash = sha256( this, tokenBuy, tokenSell, amountBuy, amountSell, nonce );
		orders[msg.sender][hash] = true;
		Order( msg.sender, tokenBuy, tokenSell, amountBuy, amountSell, nonce );
	}

	function 	orderCancel( address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, uint nonce ) public {

		bytes32 hash;

		assertQuantity( amountBuy );
		assertQuantity( amountSell );
		hash = sha256( this, tokenBuy, tokenSell, amountBuy, amountSell, nonce );
		orders[msg.sender][hash] = false;
		OrderCancel( msg.sender, tokenBuy, tokenSell, amountBuy, amountSell, nonce );
	}

	function 	trade( address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, uint nonce, address user, uint quantityBuy ) public { 

		bytes32 	hash;

		hash = sha256( this, tokenBuy, tokenSell, amountBuy, amountSell, nonce );
		
		if ( orders[user][hash] == false )
			assert( false );
		else if ( safeAdd( orderFills[user][hash], quantityBuy) > amountBuy )
			assert( false );

		tradeBalances( tokenBuy, tokenSell, amountBuy, amountSell, user, quantityBuy );
		orderFills[user][hash] = safeAdd( orderFills[user][hash], quantityBuy );
		Trade( msg.sender, user, tokenBuy, tokenSell, amountBuy, amountSell * quantityBuy / amountSell );
	}

	function tradeBalances( address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, address user, uint quantityBuy ) private {

		uint 	feeTakeXfer;

		feeTakeXfer = safeMul( quantityBuy, feeTake ) / ( 1 ether );

		tokens[tokenBuy][msg.sender] = safeSub( tokens[tokenBuy][msg.sender], safeAdd( quantityBuy, feeTakeXfer ) );
		tokens[tokenBuy][user] = safeAdd( tokens[tokenBuy][user], quantityBuy );
		tokens[tokenBuy][feeAccount] = safeAdd( tokens[tokenBuy][feeAccount], feeTakeXfer );

		tokens[tokenSell][user] = safeSub( tokens[tokenSell][user], safeMul( amountSell, quantityBuy ) / amountBuy );
		tokens[tokenSell][msg.sender] = safeAdd( tokens[tokenSell][msg.sender], safeMul( amountSell, quantityBuy) / amountBuy );
	}
}