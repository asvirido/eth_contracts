pragma solidity ^0.4.24;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
	/**
	* @dev Multiplies two numbers, throws on overflow.
	*/
	function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
		// benefit is lost if 'b' is also tested.
		if (_a == 0) {
			return 0;
		}

		c = _a * _b;
		assert(c / _a == _b);
		return c;
	}

	/**
	* @dev Integer division of two numbers, truncating the quotient.
	*/
	function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
		// uint256 c = _a / _b;
		// assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
		return _a / _b;
	}

	/**
	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
	*/
	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
		assert(_b <= _a);
		return _a - _b;
	}

	/**
	* @dev Adds two numbers, throws on overflow.
	*/
	function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
		c = _a + _b;
		assert(c >= _a);
		return c;
	}
}

/**
* @title Ownable
* @dev The Ownable contract has an owner address, and provides basic authorization control
* functions, this simplifies the implementation of "user permissions".
*/

contract Ownable {
	address public _owner;

	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


	/**
	* @dev The Ownable constructor sets the original `owner` of the contract to the sender
	* account.
	*/
	constructor() public {
		_owner = msg.sender;
	}

	/**
	* @dev Throws if called by any account other than the owner.
	*/
	modifier onlyOwner() {
		require(msg.sender == _owner);
		_;
	}

	/**
	* @dev Allows the current owner to transfer control of the contract to a newOwner.
	* @param newOwner The address to transfer ownership to.
	*/
	function transferOwnership(address newOwner) public onlyOwner {
		_transferOwnership(newOwner);
	}

	/**
	* @dev Transfers control of the contract to a newOwner.
	* @param newOwner The address to transfer ownership to.
	*/
	function _transferOwnership(address newOwner) internal {
		require(newOwner != address(0));
		emit OwnershipTransferred(_owner, newOwner);
		_owner = newOwner;
	}
}

contract 	Admins is Ownable {
	
	mapping(address => bool) internal	_moderators;

	/**
	* @dev Construct.
	*/
	constructor() public {
	}

	// check
	function	changeStatusModerator(address user, bool status) public notNullAddress(user) onlyOwner() {
		_moderator[user] = status;
	}

	function 	getModerator(address user) public constant returns (bool) {
		return 	_moderator[user];
	}

	/**
	* @dev Throws if called by any account other than the moderator.
	*/
	// check
	modifier onlyModerator() {
		require(_moderator[msg.sender] == true);
		_;
	}

	/**
	* @dev Throws if called by null account
	*/
	modifier notNullAddress(address user) {
		require(user != address(0x0));
		_;
	}
}

contract BetsMatch is Ownable {
	address public _oldSmartContract;
	string public _version;

	struct Bet {
		address player;
		uint 	amount;
		uint 	coef; // коефициент не может быть float. нужно подумать про это
	}
	
	mapping(bytes32 => Bet) _bets;

	constructor() public {
		_oldSmartContract = 0x0;
		_version = "0.01";
	}

	function 	createBet() public {
		// 
	// }
	
}
