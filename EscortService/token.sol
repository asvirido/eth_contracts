pragma solidity ^0.4.18;

contract safeMath {

	function add( uint256 x, uint256 y ) constant internal returns ( uint256 z ) {
		
		assert( ( z = x + y ) >= x );
	}

	function sub( uint256 x, uint256 y ) constant internal returns ( uint256 z ) {
		
		assert( ( z = x - y ) <= x );
	}
}

interface 	ERC20 {

	function 	totalSupply() public constant returns ( uint supply );
	function 	balanceOf( address who ) public constant returns ( uint value );
	function 	allowance( address owner, address spender ) public constant returns ( uint _allowance );

	function 	transfer( address to, uint value ) public returns ( bool ok );
	function 	transferFrom( address from, address to, uint value) public returns ( bool ok );
	function 	approve( address spender, uint value ) public returns ( bool ok );

	event 		Transfer( address indexed from, address indexed to, uint value );
	event 		Approval( address indexed owner, address indexed spender, uint value );
}

contract 	baseToken is ERC20, safeMath {

	uint256			_totalSupply;
	address			_admin;
	string 			_name;
	string			_symbol;
	uint8			_decimals;

	mapping ( address => uint256 )							_balanceOf;
	mapping ( address => mapping ( address => uint256 ) )	_allowance;

	function 	baseToken( string nameToken, string symbolToken, uint256 supply, uint8 decimals ) public {

		uint256 	balance;

		balance = supply * 10 ** uint256( decimals );
		_name = nameToken;
		_symbol = symbolToken;
		_balanceOf[msg.sender] = balance;
		_totalSupply = balance;
		_decimals = decimals;
		_admin = msg.sender;
	}

	modifier 	assertAdmin() {
		
		if ( msg.sender != _admin ) {
			assert( false );
		}
		_;
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

		assert(_balanceOf[msg.sender] >= amount);

		_balanceOf[msg.sender] = sub( _balanceOf[msg.sender], amount );
		_balanceOf[to] = add( _balanceOf[to], amount );

		Transfer( msg.sender, to, amount );

		return true;
	}

	function 	transferFrom( address from, address to, uint amount ) public returns ( bool ) {

		assert( _balanceOf[from] >= amount );
		assert( _allowance[from][msg.sender] >= amount );

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
