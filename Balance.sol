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

contract Balance {
	using SafeMath for uint;

	mapping(address => uint) public _balanceOf;
	
	event DepositEth(address user, uint amountDeposit, uint balanceNow);

	event WithdrawEth(address user, uint amountWithdraw, uint balanceNow);


	function 	depositEth() notZero(msg.value) payable public {
		_balanceOf[msg.sender] = _balanceOf[msg.sender].add(msg.value);
		emit DepositEth(msg.sender, msg.value, _balanceOf[msg.sender]);
	}

	function 	withdrawEth(uint amountWithdraw) notZero(amountWithdraw) public {
		_balanceOf[msg.sender] = _balanceOf[msg.sender].sub(amountWithdraw);
		msg.sender.transfer(amountWithdraw);
		emit WithdrawEth(msg.sender, amountWithdraw, _balanceOf[msg.sender]);
	}

	modifier 	notZero(uint amount) { 
		require(amount != 0);
		_;
	}
}
