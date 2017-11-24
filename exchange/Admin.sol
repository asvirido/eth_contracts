pragma solidity ^0.4.16;

contract Admin {

	address public	_admin;
	address public	_feeAccount;
	uint public		_feeMake; //percentage times (1 ether)
	uint public		_feeTake; //percentage times (1 ether)
	uint public		_feeRebate; //percentage times (1 ether)

	function Admin( address admin, address feeAccount, uint feeMake, uint feeTake, uint feeRebate ) public {
		_admin = admin;
		_feeAccount = feeAccount;
		_feeMake = feeMake;
		_feeTake = feeTake;
		_feeRebate = feeRebate;
	}

	modifier adminValid() {
		if ( msg.sender != _admin ) {
			require( false );
		}
		_;
	}

	function setAdmin( address admin ) adminValid public {
		_admin = admin;
	}

	function setFeeAccount( address feeAccount ) adminValid public {
		_feeAccount = feeAccount;
	}

	function  setFeeMake( uint feeMake ) adminValid public {
		_feeMake = feeMake;
	}

	function setFeeTake( uint feeTake ) adminValid public {
		_feeTake = feeTake;
	}

	function setFeeRebate( uint feeRebate ) adminValid public {
		_feeRebate = feeRebate;
	}
}