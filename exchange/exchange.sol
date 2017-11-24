pragma solidity ^0.4.16;

contract SafeMath {

	function safeMul(uint a, uint b) internal returns (uint) {
		uint c = a * b;
		assert(a == 0 || c / a == b);
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

contract Admin {

	address public	_admin;
	address public	_feeAccount;
	uint public		_feeMake; //percentage times (1 ether)
	uint public		_feeTake; //percentage times (1 ether)
	uint public		_feeRebate; //percentage times (1 ether)

	modifier assertAdmin() {
		if ( msg.sender != _admin ) {
			require( false );
		}
		_;
	}

	function setAdmin( address admin ) assertAdmin public {
		_admin = admin;
	}

	function setFeeAccount( address feeAccount ) assertAdmin public {
		_feeAccount = feeAccount;
	}

	function  setFeeMake( uint feeMake ) assertAdmin public {
		_feeMake = feeMake;
	}

	function setFeeTake( uint feeTake ) assertAdmin public {
		_feeTake = feeTake;
	}

	function setFeeRebate( uint feeRebate ) assertAdmin public {
		_feeRebate = feeRebate;
	}
}

contract Exchange is Admin, SafeMath{

	// mapping

	// Event 

	function Exchange( address admin, address feeAccount, uint feeMake, uint feeTake, uint feeRebate ) {
		_admin = admin;
		_feeAccount = feeAccount;
		_feeMake = feeMake;
		_feeTake = feeTake;
		_feeRebate = feeRebate;
	}

	function order() {
		// code	
	}

	function  depositEth() payable {
		// code
	}

	function depositToken() {
		// code
	}
	
	function withdrawEth() {
		// code
	}
	
	function withdrawToken() {
		//code
	}	
}
// 0x4e760c6Eb830688aaCC4AE30B8f92034Aab911fb