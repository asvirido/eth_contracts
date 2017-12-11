pragma solidity ^0.4.16;

contract SafeMath {

	function safeMul( uint a, uint b ) internal returns ( uint ) {
		
		uint 	c;
		
		c = a * b;
		assert( a == 0 || c / a == b );
		return c;
	}

	function safeSub( uint a, uint b ) internal returns ( uint ) {
		
		assert( b <= a );
		return a - b;
	}

	function safeAdd( uint a, uint b ) internal returns ( uint ) {
		
		uint 	c;
	
		c = a + b;
		assert( c >= a && c >= b );
		return c;
	}
}

/*
* Interface ERC20
*/

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
	string  public 	version;
	uint 	public	feeTake; //percentage times (1 ether)

	modifier assertAdmin() {
		
		if ( msg.sender != admin ) {
			assert( false );
		}
		_;
	}

	function setAdmin( address _admin ) assertAdmin public {
		
		admin = _admin;
	}

	function setVersion(string _version) assertAdmin public {
		version = _version;	
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
	mapping( bytes32 => mapping( address => uint )) public ordersBalance;
	mapping( address => mapping( bytes32 => uint )) public orderFills;

	event Deposit( address token, address user, uint amount, uint balance );
	event Withdraw( address token, address user, uint amount, uint balance );
	event Order( address user, address tokenTake, uint amountTake, address tokenMake, uint amountMake, uint nonce );
	event OrderCancel( address user, address tokenTake, uint amountTake, address tokenMake, uint amountMake, uint nonce );
	event Trade( address makeAddress, address tokenMake, uint amountGiveMake, address takeAddress, address tokenTake, uint quantityTake, uint feeTakeXfer);
	
	function Exchange( address _admin, address _feeAccount, uint _feeTake, string _version) public {
		
		admin = _admin;
		feeAccount = _feeAccount;
		feeTake = _feeTake;
		orderEnd = true;
		version = _version;
	}

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
	
	function 	order( address tokenTake, address tokenMake, uint amountTake, uint amountMake, uint nonce ) public {

		bytes32 	hash;

		assertQuantity( amountTake );
		assertQuantity( amountMake );

		if ( orderEnd == false )
			assert( false );
		if ( tokens[tokenMake][msg.sender] < amountMake )
			assert( false );
		
		hash = sha256( this, tokenTake, tokenMake, amountTake, amountMake, nonce );
		
		orders[msg.sender][hash] = true;
		tokens[tokenMake][msg.sender] = safeSub( tokens[tokenMake][msg.sender], amountMake );
		ordersBalance[hash][msg.sender] = amountMake;

		Order( msg.sender, tokenTake, amountTake, tokenMake, amountMake, nonce );
	}

	function 	orderCancel( address tokenTake, address tokenMake, uint amountTake, uint amountMake, uint nonce ) public {

		bytes32 	hash;

		assertQuantity( amountTake );
		assertQuantity( amountMake );

		hash = sha256( this, tokenTake, tokenMake, amountTake, amountMake, nonce );
		orders[msg.sender][hash] = false;
		
		tokens[tokenMake][msg.sender] = safeAdd( tokens[tokenMake][msg.sender], ordersBalance[hash][msg.sender]);
		ordersBalance[hash][msg.sender] = 0;
		OrderCancel( msg.sender, tokenTake, amountTake, tokenMake, amountMake, nonce );
	}

	function 	trade( address tokenTake, address tokenMake, uint amountTake, uint amountMake, uint nonce, address makeAddress, uint quantityTake ) public { 

		bytes32 	hash;

		hash = sha256( this, tokenTake, tokenMake, amountTake, amountMake, nonce );

		if ( orders[makeAddress][hash] == false )
			assert( false );
		else if ( safeAdd( orderFills[makeAddress][hash], quantityTake) > amountTake )
			assert( false );
		
		tradeBalances( tokenTake, tokenMake, amountTake, amountMake, makeAddress, quantityTake, hash);
		orderFills[makeAddress][hash] = safeAdd( orderFills[makeAddress][hash], quantityTake );		
	}

	function tradeBalances( address tokenTake, address tokenMake, uint amountTake, uint amountMake, address makeAddress, uint quantityTake, bytes32 hash) private {

		uint 		feeTakeXfer;
		address 	takeAddress;
		uint 		amountGiveMake;

		takeAddress = msg.sender;
		feeTakeXfer = safeMul( quantityTake, feeTake ) / ( 1 ether );
		amountGiveMake = safeMul( amountMake, quantityTake ) / amountTake;

		tokens[tokenTake][takeAddress] = safeSub( tokens[tokenTake][takeAddress], safeAdd( quantityTake, feeTakeXfer ) );
		tokens[tokenTake][makeAddress] = safeAdd( tokens[tokenTake][makeAddress], quantityTake );
		tokens[tokenTake][feeAccount] = safeAdd( tokens[tokenTake][feeAccount], feeTakeXfer );

		ordersBalance[hash][makeAddress] = safeSub( ordersBalance[hash][makeAddress], amountGiveMake );
		tokens[tokenMake][takeAddress] = safeAdd( tokens[tokenMake][takeAddress], amountGiveMake );

		Trade( makeAddress, tokenMake, amountGiveMake, takeAddress, tokenTake, quantityTake, feeTakeXfer);
	}
}
