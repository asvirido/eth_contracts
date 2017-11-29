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

	function totalSupply() constant returns ( uint256 supply );
	
	function balanceOf( address _owner ) constant returns ( uint256 balance );
	
	function transfer( address _to, uint256 _value ) returns ( bool success );
	
	function transferFrom( address _from, address _to, uint256 _value ) returns ( bool success );
	
	function approve( address _spender, uint256 _value ) returns ( bool success );

	function allowance( address _owner, address _spender ) constant returns ( uint256 remaining );
	
	event Transfer( address indexed _from, address indexed _to, uint256 _value );

	event Approval( address indexed _owner, address indexed _spender, uint256 _value );
}

contract Exchange is SafeMath {

    mapping( address => mapping( address => uint )) public tokens;
    mapping( address => mapping( bytes32 => bool )) public orders;
    mapping( address => mapping( bytes32 => uint )) public orderFills;

    event Deposit( address token, address user, uint amount, uint balance );
    event Withdraw( address token, address user, uint amount, uint balance );
    event Order( address user, address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, uint endBlock, uint startBlock );
    event OrderCancel( address user, address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, uint endBlock, uint startBlock );
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

    function 	depositEth() payable {
		
    	assertQuantity( msg.value );
		tokens[0][msg.sender] = safeAdd( tokens[0][msg.sender], msg.value );
		Deposit( 0, msg.sender, msg.value, tokens[0][msg.sender] );
    }

    function 	withdrawEth( uint amount ) {
		
		assertQuantity( amount );
		if ( msg.sender.call.value( amount )() == false ) {
			assert( false );
		}
		tokens[0][msg.sender] = safeSub( tokens[0][msg.sender], amount );
		Withdraw( 0, msg.sender, amount, tokens[0][msg.sender] );
	}

	function 	depositToken( address token, uint amount ) {
		
		assertToken( token );
		assertQuantity( amount );
		if ( Token( token ).transferFrom( msg.sender, this, amount ) == false ) {
			assert( false );
		}
		tokens[token][msg.sender] = safeAdd( tokens[token][msg.sender], amount );
		Deposit( token, msg.sender, amount, tokens[token][msg.sender] );
	}

	function 	withdrawToken( address token, uint amount ) {
		
		assertToken( token );
		assertQuantity( amount );
		if ( Token( token ).transfer( msg.sender, amount ) == false ) {
			assert( false );
		}
		tokens[token][msg.sender] = safeSub( tokens[token][msg.sender], amount );
	    Withdraw( token, msg.sender, amount, tokens[token][msg.sender] );
	}
	
	function 	order( address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, uint endBlock, uint startBlock ) {

		bytes32 	hash;

		assertQuantity( amountBuy );
		assertQuantity( amountSell );
		hash = sha256( this, tokenBuy, tokenSell, amountBuy, amountSell, endBlock, startBlock );
		orders[msg.sender][hash] = true;
		Order( msg.sender, tokenBuy, tokenSell, amountBuy, amountSell, endBlock, startBlock );
	}

	function 	orderCancel( address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, uint endBlock, uint startBlock ) {
		
		bytes32 hash;

		assertQuantity( amountBuy );
		assertQuantity( amountSell );
		hash = sha256( this, tokenBuy, tokenSell, amountBuy, amountSell, endBlock, startBlock );
		orders[msg.sender][hash] = false;
		OrderCancel( msg.sender, tokenBuy, tokenSell, amountBuy, amountSell, endBlock, startBlock );
	}

	function 	trade( address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, uint endBlock, uint startBlock, address user, uint quantityBuy ) { 

		bytes32 	hash;

		hash = sha256( this, tokenBuy, tokenSell, amountBuy, amountSell, endBlock, startBlock );
		if ( orders[user][hash] == false )
			assert( false );
		else if ( block.number > endBlock )
			assert( false );
		else if ( safeAdd( orderFills[user][hash], quantityBuy) > amountBuy )
			assert( false );
		
		tradeBalances( tokenBuy, tokenSell, amountBuy, amountSell, user, quantityBuy );
		orderFills[user][hash] = safeAdd( orderFills[user][hash], quantityBuy );
		Trade( msg.sender, user, tokenBuy, tokenSell, amountBuy, amountSell * quantityBuy / amountSell );
	}

	function tradeBalances( address tokenBuy, address tokenSell, uint amountBuy, uint amountSell, address user, uint quantityBuy ) private {
		
		uint 	feeMakeXfer;
		uint 	feeTakeXfer; 
		uint 	feeMake;
		uint 	feeTake;

		feeTake = 1;
		feeMake = 1;
		feeMakeXfer = safeMul( quantityBuy, feeMake ) / ( 1 ether );
		feeTakeXfer = safeMul( quantityBuy, feeTake ) / ( 1 ether );

		tokens[tokenBuy][msg.sender] = safeSub( tokens[tokenBuy][msg.sender], safeAdd( quantityBuy, feeTakeXfer ) );

		tokens[tokenBuy][user] = safeAdd( tokens[tokenBuy][user], safeSub( quantityBuy, feeMakeXfer) );
		
		tokens[tokenBuy][this] = safeAdd( tokens[tokenBuy][this], safeAdd( feeMakeXfer, feeTakeXfer ) );
		tokens[tokenSell][user] = safeSub( tokens[tokenSell][user], safeMul( amountSell, quantityBuy ) / amountBuy );
		tokens[tokenSell][msg.sender] = safeAdd( tokens[tokenSell][msg.sender], safeMul( amountSell, quantityBuy) / amountBuy );
	}
}
