pragma solidity ^0.4.16;

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

	function changeFeeRebate( uint feeRebate ) adminValid public {
		_feeRebate = feeRebate;
	}
}