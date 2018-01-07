contract Admin {

	address public	admin;
	address public	feeAccount; // address feeAccount, which will receive fee.
	address public 	nextVersionAddress; // this is next address exchange
	bool 	public	orderEnd; // this is var use when Admin want close exchange
	string  public 	version; // number version example 1.0, test_1.0
	uint 	public	feeTake; //percentage times (1 ether)

	modifier assertAdmin() {
		if ( msg.sender != admin ) {
			assert( false );
		}
		_;
	}

	/*
	*	This is function, is needed to change address admin.
	*/
	function setAdmin( address _admin ) assertAdmin public {
		admin = _admin;
	}

	/*
	* 	This is function, is needed to change version smart-contract.
	*/
	function setVersion(string _version) assertAdmin public {
		version = _version;	
	}

	/*
	* 	This is function, is needed to set address, next smart-contracts.
	*/
	function setNextVersionAddress(address _nextVersionAddress) assertAdmin public{
		nextVersionAddress = _nextVersionAddress;	
	}

	/*
	* 	This is function, is needed to stop, news orders.
	*	Can not turn off it.
	*/
	function setOrderEnd() assertAdmin public {
		orderEnd = true;
	}

	/*
	*	This is function, is needed to change address feeAccount.
	*/
	function setFeeAccount( address _feeAccount ) assertAdmin public {
		feeAccount = _feeAccount;
	}

	/*
	* 	This is function, is needed to set new fee.
	*	Can only be changed down.
	*/
	function setFeeTake( uint _feeTake ) assertAdmin public {
		if ( _feeTake > feeTake )
			assert( false );
		feeTake = _feeTake;
	}
}