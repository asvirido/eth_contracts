pragma solidity ^0.4.18;

import "browser/safeMath.sol";
import "browser/IERC20.sol";

contract 	ERC20 is safeMath, IERC20 {
	uint256			_totalSupply;
	string 			_name;
	string			_symbol;
	uint8			_decimals;

	mapping ( address => uint256 )							_balanceOf;
	mapping ( address => mapping ( address => uint256 ) )	_allowance;

	function 	ERC20( string nameToken, string symbolToken, uint256 supply, uint8 decimals ) public {
		uint256 	balance;

		balance = supply * 10 ** uint256( decimals );
		_name = nameToken;
		_symbol = symbolToken;
		_balanceOf[msg.sender] = balance;
		_totalSupply = balance;
		_decimals = decimals;
	}

	function 	totalSupply() public constant returns ( uint256 ) {
		return _totalSupply;
	}

	function 	balanceOf( address user ) public constant returns ( uint256 ) {
		return _balanceOf[user];
	}

	function 	allowance( address owner, address spender ) public constant returns ( uint256 ) {
		return _allowance[owner][spender];
	}

	function 	transfer( address to, uint amount ) public returns ( bool ) {
		require(_balanceOf[msg.sender] >= amount);

		_balanceOf[msg.sender] = sub( _balanceOf[msg.sender], amount );
		_balanceOf[to] = add( _balanceOf[to], amount );

		Transfer( msg.sender, to, amount );
		return true;
	}

	function 	transferFrom( address from, address to, uint amount ) public returns ( bool ) {
		require( _balanceOf[from] >= amount );
		require( _allowance[from][msg.sender] >= amount );

		_allowance[from][msg.sender] = sub( _allowance[from][msg.sender], amount );
		_balanceOf[from] = sub( _balanceOf[from], amount );
		_balanceOf[to] = add( _balanceOf[to], amount );

		Transfer( from, to, amount );
		return true;
	}

	function 	approve( address spender, uint256 amount ) public returns ( bool ) {
		_allowance[msg.sender][spender] = amount;

		Approval( msg.sender, spender, amount );
		return true;
	}
}
