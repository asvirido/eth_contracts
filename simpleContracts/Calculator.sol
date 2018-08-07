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

contract Calculator {
    using SafeMath for uint;

    function sub(uint a, uint b) pure public returns(uint) {
        return (a.sub(b));
    }
    
    function add(uint a, uint b) pure public returns(uint) {
        return (a.add(b));
    }
    
    function div(uint a, uint b) pure public returns(uint) {
        return (a.div(b));
    }
    
    function mul(uint a, uint b) pure public returns(uint) {
        return (a.mul(b));
    }
}


