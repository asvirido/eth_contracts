pragma solidity ^0.4.16;

contract Owner {
	address owner;
	
	function Owner() public {
		owner = msg.sender;
	}

	modifier ownerValid() { 
		if (msg.sender != owner) {
			require(false);
		}
		_; 
	}
}