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

	// address public _prevSmartContract;
	// address public _nextSmartContract;
	// string 	public _version;

	// for test
	address private _prevSmartContract;
	address private _nextSmartContract;
	string 	private _version; 

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

	mapping(bytes32 => Bet) public _bets;

	struct Bet {
		address player;
		string 	nameEvent; /* only english string*/
		uint 	amountBookmaker;
		uint    amountPlayer;
		uint8 	coef; /* float don't available */
		uint 	minutesDeadlineCancel;
	}
	
	event CreateBet(
		bytes32 hashBet,
		string nameEvent,
		address player,
		uint amountBookmaker,
		uint8 coef,
		uint minutesDeadlineCancel
	);
	
	event AcceptBet(
		bytes32 hashBet,
		string nameEvent,
		address player,
		uint amountBookmaker,
		uint amountPlayer,
		uint8 coef,
		uint minutesDeadlineCancel
	);
	
	event CancelBet(
		bytes32 hashBet,
		string nameEvent,
		address player,
		uint amountBookmaker,
		uint amountPlayer,
		uint8 coef,
		uint minutesDeadlineCancel
	);
	
	constructor() public {
		// some code
	}

	/**
	* some comment
	*/
	function 	createBet(
		bytes32 hashBet,
		string nameEvent,
		address player,
		uint minutesDeadlineCancel,
		uint8 coef
	)
		public
		payable
		onlyModerator()
		notNullAddress(player)
		notZeroAmountEther()
	{
		require(_bets[hashBet].player == address(0x0));	
		uint  amountBookmaker = msg.value;

		Bet memory bet = Bet(
			player,
			nameEvent, /* only English */
			amountBookmaker, /* wei */
			0, /* wei amountPlayer */
			coef, /* x2 x4 etc */
			minutesDeadlineCancel
		);
		_bets[hashBet] = bet;
		emit CreateBet(
			hashBet,
			nameEvent,
			player,
			amountBookmaker,
			coef,
			minutesDeadlineCancel
		);
	}

	/**
	* some comment
	*/
	function 	acceptBet(
		bytes32 hashBet
	)
		public
		payable
		notZeroAmountEther()
		onlyForPlayerOfThisBet(hashBet)
	{
		require(_bets[hashBet].player == msg.sender);
		require(_bets[hashBet].amountPlayer == msg.value.div(_bets[hashBet].coef));

		_bets[hashBet].amountPlayer = msg.value;
		emit AcceptBet(
			hashBet,
			_bets[hashBet].nameEvent,
			msg.sender,
			_bets[hashBet].amountBookmaker,
			msg.value,
			_bets[hashBet].coef,
			_bets[hashBet].minutesDeadlineCancel
		);
	}

	/**
	* some comment
	*/
	function 	cancelBet(
		bytes32 hashBet
	)
		public
		onlyForPlayerOfThisBet(hashBet)
	{
		emit CancelBet(
			hashBet,
			_bets[hashBet].nameEvent,
			_bets[hashBet].player,
			_bets[hashBet].amountBookmaker,
			_bets[hashBet].amountPlayer,
			_bets[hashBet].coef,
			_bets[hashBet].minutesDeadlineCancel
		);
	}

	modifier 	notZeroAmountEther() { 
		require(msg.value != 0);
		_;
	}

	modifier	onlyForPlayerOfThisBet(bytes32 hashBet) { 
		require (_bets[hashBet].player == msg.sender);
		_;
	}

	modifier 	deadline(uint time) { 
		require (now >= time); 
		_;
	}
}
