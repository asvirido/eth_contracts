pragma solidity ^0.4.18;

contract Passport {
	function getTrueUser(address user) public view returns(bool);
}

contract Election {
	address public _AddressContractPassport;
	uint8 public _amountPosition;
	uint8 public _maxSizePositions;
	bool public _endVoting = false;
	address public _owner;

	Passport private _passportContract;
	uint8 private _win;

	mapping(address => bool) public _vote;
	
	mapping(uint8 => uint256) private _amountVote;

	constructor(address contractOfPassport) public {
		_AddressContractPassport = contractOfPassport;	
		_owner = msg.sender;
		_passportContract = Passport(contractOfPassport);		
		_maxSizePositions = 3;
	}

	/*
	** For users
	*/

	function votingForAPosition(uint8 position) public {
		if (_vote[msg.sender] == true || _endVoting == true) {
			revert();
		} else if (_passportContract.getTrueUser(msg.sender) == false) {
			revert();
		} else if (position < 0 || position > _amountPosition) {
			revert();
		} else {
			_amountVote[position] += 1;
			_vote[msg.sender] = true;
		}
	}

	/*
	** For admin
	*/

	function createNewPosition() public {
		if (msg.sender != _owner || _amountPosition >= _maxSizePositions) {
			revert();
		}
		_amountPosition += 1;
	}

	function end() public {
		if (msg.sender != _owner || _endVoting == true) {
			revert();
		} else {
			_endVoting = true;
		}
	}

	function calcWin() public {
		if (msg.sender != _owner || _endVoting == false) {
			revert();
		}
		uint8 i = 0;
		uint256 maxAmount = 0;
		uint8 win = 0;
		while (i < _amountPosition) {
			if (maxAmount < _amountVote[i]) {
				maxAmount = _amountVote[i];
				win = i;
			}
			i += 1;
		}
		_win = win;
	}

	function whoWin() public view returns(uint8) {
		if (_endVoting == false) {
			revert();
		}
		return (_win);
	}
}
