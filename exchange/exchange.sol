pragma solidity ^0.4.6;

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
	
	address public	admin;
	address public	feeAccount;
	uint public		feeMake; //percentage times (1 ether)
	uint public		feeTake; //percentage times (1 ether)
	uint public		feeRebate; //percentage times (1 ether)

	function Admin( address admin, address feeAccount, uint feeMake, uint feeTake, uint feeRebate ) public {
		_admin = admin;
		_feeAccount = feeAccount;
		_feeMake = feeMake;
		_feeTake = feeTake;
		_feeRebate = feeRebate;
	}

	modifier adminValid() {
		if ( msg.sender != admin ) {
			require( false );
		}
		_;
	}

	function changeAdmin( address admin ) adminValid public {
		_admin = admin;
	}

	function changeFeeAccount( address feeAccount ) adminValid public {
		_feeAccount = feeAccount;
	}

	function  changeFeeMake( uint feeMake ) adminValid public {
		_feeMake = feeMake;
	}

	function changeFeeTake( uint feeTake ) adminValid public {
		_feeTake = feeTake;
	}

	function changeFeeRebate( uint feeRebate) adminValid public {
		_feeRebate = feeRebate;
	}
	
}
