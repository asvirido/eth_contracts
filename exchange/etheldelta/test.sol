pragma solidity ^0.4.16;

contract SafeMath {

    function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        // assert(a == 0 || c / a == b);
        return c;
    }
    
    function safeSub(uint a, uint b) internal returns (uint) {
		assert(b <= a);
		return a - b;
    }

    function safeAdd(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        // assert(c>=a && c>=b);
        return c;
    }
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

    function  depositEth() payable assertQuantity(msg.value) {
        tokens[0][msg.sender] = safeAdd( tokens[0][msg.sender], msg.value );
        Deposit( 0, msg.sender, msg.value, tokens[0][msg.sender] );
    }

    function withdrawEth( uint amount ) assertQuantity(amount) {
		if ( !msg.sender.call.value( amount )()) {
			assert( false );
		}
		tokens[0][msg.sender] = safeSub( tokens[0][msg.sender], amount );
		Withdraw( 0, msg.sender, amount, tokens[0][msg.sender] );
	}
}

// main 0x366646B71499578aF3F59E61f9f4E4e0B0850C7c
// two  0xccEFa1CE284008Aa47A2Da1223E334363eAEf3f0s