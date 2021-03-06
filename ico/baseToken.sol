pragma solidity ^0.4.16;

contract safeMath {

	function add( uint256 x, uint256 y ) constant internal returns ( uint256 z ) {
		
		assert( ( z = x + y ) >= x );
	}

	function sub( uint256 x, uint256 y ) constant internal returns ( uint256 z ) {
		
		assert( ( z = x - y ) <= x );
	}
}

contract ERC20 {

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

	event Burn( address indexed from, uint256 value );

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

	function 	addTotalSupply( uint256 newBalance ) public assertAdmin {
		
		_balanceOf[_admin] = add( _balanceOf[_admin], newBalance );
		_totalSupply = add( _totalSupply, newBalance );
	}

	function 	burn( uint256 value ) public returns ( bool success ) {
		
		assert( _balanceOf[msg.sender] >= value );	// Check if the sender has enough
		
		_balanceOf[msg.sender] -= value;			// Subtract from the sender
		_totalSupply -= value;						// Updates _totalSupply
		Burn( msg.sender, value );
		return true;
	}

	function 	burnFrom( address from, uint256 value ) public returns ( bool success ) {

		assert( _balanceOf[from] >= value );					// Check if the targeted balance is enough
		assert( value <= _allowance[from][msg.sender] );		// Check allowance

		_balanceOf[from] -= value;							// Subtract from the targeted balance
		_allowance[from][msg.sender] -= value;				// Subtract from the sender's allowance
		_totalSupply -= value;								// Update _totalSupply
		
		Burn( from, value );
		return true;
	}
}
