pragma solidity ^0.4.16;

contract SafeMath {

    function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        //assert(a == 0 || c / a == b);
        return c;
    }
    
    function safeSub(uint a, uint b) internal returns (uint) {
		assert(b <= a);
		return a - b;
    }

    function safeAdd(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c>=a && c>=b);
        return c;
    }
}

contract Token {

	uint public 	decimals;
	string public 	name;
	
	function totalSupply() constant returns (uint256 supply);
	
	function balanceOf(address _owner) constant returns (uint256 balance);
	
	function transfer(address _to, uint256 _value) returns (bool success);
	
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
	
	function approve(address _spender, uint256 _value) returns (bool success);

	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
	
	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Exchange is SafeMath {

    mapping( address => mapping( address => uint )) public tokens;

    event Deposit(address token, address user, uint amount, uint balance);
    event Withdraw(address token, address user, uint amount, uint balance);
    
    modifier assertQuantity( uint amount ) { 
        if ( amount == 0 ) {
            assert( false );
        }
        _;
    }

	modifier assertToken( address token ) { 
		if ( token == 0 ) {
			assert( false );
		}
		_; 
	}

    function 	depositEth() payable assertQuantity( msg.value ) {
		tokens[0][msg.sender] = safeAdd( tokens[0][msg.sender], msg.value );
		Deposit( 0, msg.sender, msg.value, tokens[0][msg.sender] );
    }

    function 	withdrawEth( uint amount ) assertQuantity( amount ) {
		if ( !msg.sender.call.value( amount )()) {
			assert( false );
		}
		tokens[0][msg.sender] = safeSub( tokens[0][msg.sender], amount );
		Withdraw( 0, msg.sender, amount, tokens[0][msg.sender] );
	}

	function 	depositToken( address token, uint amount ) assertToken( token ) assertQuantity( amount ) {
		if ( !Token( token ).transferFrom( msg.sender, this, amount )) {
			assert( false );
		}
		tokens[token][msg.sender] = safeAdd( tokens[token][msg.sender], amount );
		Deposit( token, msg.sender, amount, tokens[token][msg.sender] );
	}

	function 	withdrawToken( address token, uint amount ) assertToken( token ) assertQuantity( amount ) {
		if ( !Token( token ).transfer( msg.sender, amount ) ) {
			assert( false );
		}
	    tokens[token][msg.sender] = safeSub( tokens[token][msg.sender], amount );
	    Withdraw( token, msg.sender, amount, tokens[token][msg.sender] );
	}
}
/*

*/
// main 0x366646B71499578aF3F59E61f9f4E4e0B0850C7c
// two  0xccEFa1CE284008Aa47A2Da1223E334363eAEf3f0
// address token 0xa2b27091FEaef327D7e25CD95da784E0465A6f18