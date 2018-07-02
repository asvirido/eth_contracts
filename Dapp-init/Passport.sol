pragma solidity ^0.4.18;

contract Passport {
	struct DataPerson {
		string 		firstName;
		string 		lastName;
		uint8 		age;
		uint256 	personId;
	}

	uint256 public _amountId;

	mapping(address => DataPerson) private _users;

	/*
	** public
	*/

	function registrationNewUseR(string firstName, string lastName, uint8 age) public {
		if (_users[msg.sender].age != 0 && age != 0) {
			revert();
		} else {
			_amountId += 1;
			dumpInData(firstName, lastName, age);
		}
	}

	function getUserFirstName(address user) public view returns(string) {
		return (_users[user].firstName);
	}

	function getUserLastName(address user) public view returns(string) {
		return (_users[user].lastName);
	}

	function getUserAge(address user) public view returns(uint8) {
		return (_users[user].age);
	}

	function getTrueUse(address user) public view returns(bool) {
		return (_users[user].personId != 0);
	}

	function getUserId(address user) public view returns(uint256) {
		return (_users[user].personId);
	}

	/* 
	** private
	*/

	function dumpInData(string firstName, string lastName, uint8 age) private {
		DataPerson 	memory dataPerson = DataPerson(
			firstName,
			lastName,
			age,
			_amountId
			);
		_users[msg.sender] = dataPerson;
	}
}