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
		require(newOwner != _owner);
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
	
	mapping(address => bool) internal _moderators;

	address public _prevSmartContract;
	address public _nextSmartContract;
	string 	public _version;

	/**
	* @dev Construct.
	*/
	constructor() public {
		_prevSmartContract = address(0x0);
		_nextSmartContract = address(0x0);
		_version = "0.01";
		_moderators[msg.sender] = true;
	}

	function	changeStatusModerator(
		address user,
		bool status
	)
		public
		notNullAddress(user)
		onlyOwner()
	{
		_moderators[user] = status;
	}
	
	function 	setNextSmartContract(
		address smartContract
	)
		public
		notNullAddress(smartContract)
		onlyOwner()
	{
		_nextSmartContract = smartContract;
	}

	/**
	* @dev Throws if called by any account other than the moderator.
	*/
	modifier onlyModerator() {
		require(_moderators[msg.sender] == true);
		_;
	}

	/**
	* @dev Throws if called by null account
	* @param user The address to check at zero address
	*/
	modifier notNullAddress(address user) {
		require(user != address(0x0));
		_;
	}

	/**
	* 	gets methods
	*	@param user The address to get status user
	*/
	function 	getStatusModerator(address user) public constant returns (bool) {
		return 	(_moderators[user]);
	}
}

contract BetsMatch is Admins {
	using SafeMath for uint;

	struct Bet {
		address player;
		string 	nameEvent; // Чем меньше символов тем лучше. Меньше газа. Можно записать только в анг буквах
		uint 	amount;
		uint 	minutesDeadLineCancel;
		uint 	coef; // коефициент не может быть float. нужно подумать про это
	}
	
	event createBet(bytes32 hashBet, string nameEvent);
	mapping(bytes32 => Bet) _bets;
	
	constructor() public {
	}

	function 	createBet(
		bytes32 hashBet,
		string nameEvent,
		address player,
		uint minutesDeadLineCancel,
		uint amount;
		uint coef
	)
		public
		payable
		onlyModerator()
		notNullAddress(player)
		notZeroAmountEther()
	{
		require(_bets[hashBet].player == address(0x0));	
	}

	function 	acceptBet(
		bytes32 hashBet
	)
		public
		payable
		notZeroAmountEther()
	{
		require(_bets[hashBet].player == msg.sender);
	}

	modifier 	notZeroAmountEther() { 
		require(msg.value != 0);
		_; 
	}
}
