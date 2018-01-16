pragma solidity ^0.4.18;

import "SafeMath.sol";
import "Token.sol";
import "Admin.sol";

contract Exchange is SafeMath, Admin {

	mapping( address => mapping( address => uint )) public tokens;
	mapping( address => mapping( bytes32 => bool )) public orders;
	mapping( bytes32 => mapping( address => uint )) public ordersBalance;

	event Deposit( address token, address user, uint amount, uint balance );
	event Withdraw( address token, address user, uint amount, uint balance );
	event Order( address user, address tokenTake, uint amountTake, address tokenMake, uint amountMake, uint nonce );
	event OrderCancel( address user, address tokenTake, uint amountTake, address tokenMake, uint amountMake, uint nonce );
	event Trade( address makeAddress, address tokenMake, uint amountGiveMake, address takeAddress, address tokenTake, uint quantityTake, uint feeTakeXfer, uint balanceOrder );

	function Exchange( address _admin, address _feeAccount, uint _feeTake, string _version) public {
		admin = _admin;
		feeAccount = _feeAccount;
		feeTake = _feeTake;
		orderEnd = false;
		version = _version;
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
		Deposit( token, msg.sender, amount , tokens[token][msg.sender] );
	}

	function 	withdrawToken( address token, uint amount ) public {
		assertToken( token );
		assertQuantity( amount );
		if ( Token( token ).transfer( msg.sender, amount ) == false ) {
			assert( false );
		}
		tokens[token][msg.sender] = safeSub( tokens[token][msg.sender], amount ); // уязвимость двойного входа?
	    Withdraw( token, msg.sender, amount, tokens[token][msg.sender] );
	}
	
	function 	order( address tokenTake, uint amountTake, address tokenMake, uint amountMake, uint nonce ) public {
		bytes32 	hash;

		assertQuantity( amountTake );
		assertQuantity( amountMake );
		assertCompareBalance( amountMake, tokens[tokenMake][msg.sender] );
		if ( orderEnd == true )
			assert( false );
		
		hash = sha256( this, tokenTake, tokenMake, amountTake, amountMake, nonce );
		
		orders[msg.sender][hash] = true;
		tokens[tokenMake][msg.sender] = safeSub( tokens[tokenMake][msg.sender], amountMake );
		ordersBalance[hash][msg.sender] = amountMake;

		Order( msg.sender, tokenTake, amountTake, tokenMake, amountMake, nonce );
	}

	function 	orderCancel( address tokenTake, uint amountTake, address tokenMake, uint amountMake, uint nonce ) public {
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
		uint 		amountGiveMake;

		assertQuantity( quantityTake );

		hash = sha256( this, tokenTake, tokenMake, amountTake, amountMake, nonce );
		assertOrders( makeAddress, hash );
		
		amountGiveMake = safeMul( amountMake, quantityTake ) / amountTake;
		assertCompareBalance ( amountGiveMake, ordersBalance[hash][makeAddress] );
		
		tradeBalances( tokenTake, tokenMake, amountTake, amountMake, makeAddress, quantityTake, hash);
	}

	function 	tradeBalances( address tokenTake, address tokenMake, uint amountTake, uint amountMake, address makeAddress, uint quantityTake, bytes32 hash) private {
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

		Trade( makeAddress, tokenMake, amountGiveMake, takeAddress, tokenTake, quantityTake, feeTakeXfer, ordersBalance[hash][makeAddress] );
	}

	function 	assertQuantity( uint amount ) private {
		if ( amount == 0 ) {
			assert( false );
		}
	}

	function 	assertToken( address token ) private { 
		if ( token == 0 ) {
			assert( false );
		}
	}


	function 	assertOrders( address makeAddress, bytes32 hash ) private {
		if ( orders[makeAddress][hash] == false ) {
			assert( false );
		}
	}

	function 	assertCompareBalance( uint a, uint b ) private {
		if ( a > b ) {
			assert( false );
		}
	}
}
