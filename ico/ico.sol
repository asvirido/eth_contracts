contract safeMath {

    function add( uint256 x, uint256 y ) constant internal returns ( uint256 z ) {
        assert( ( z = x + y ) >= x );
    }

    function sub( uint256 x, uint256 y ) constant internal returns ( uint256 z ) {
        assert( ( z = x - y ) <= x );
    }
}

contract ERC20 {
    
    function 	totalSupply() constant returns ( uint supply );
    function 	balanceOf( address who ) constant returns ( uint value );
    function 	allowance( address owner, address spender ) constant returns ( uint _allowance );

    function 	transfer( address to, uint value ) returns ( bool ok );
    function 	transferFrom( address from, address to, uint value) returns ( bool ok );
    function 	approve( address spender, uint value ) returns ( bool ok );

    event 		Transfer( address indexed from, address indexed to, uint value );
    event 		Approval( address indexed owner, address indexed spender, uint value );
}

contract 	DSTokenBase is ERC20, safeMath {

	uint256			_supply;
	string 			_name;
	string			_symbol;
	uint8			_decimals;

	mapping ( address => uint256 )							_balances;
	mapping ( address => mapping ( address => uint256 ) )	_approvals;

	function 	DSTokenBase( string nameToken, string symbolToken, uint256 supply, uint8 decimals ) {
		
		uint256 	balance;


		balance = supply * 10 ** uint256( decimals );
		_name = nameToken;
		_symbol = symbolToken;
		_balances[msg.sender] = balance;
		_supply = balance;
		_decimals = decimals;
	}

	function 	totalSupply() constant returns ( uint256 ) {

		return _supply;
	}

	function 	balanceOf( address user ) constant returns ( uint256 ) {
		
		return _balances[user];
	}

	function 	allowance( address owner, address spender ) constant returns ( uint256 ) {
		
		return _approvals[owner][spender];
	}

	function 	transfer( address to, uint amount ) returns ( bool ) {

		assert(_balances[msg.sender] >= amount);

		_balances[msg.sender] = sub( _balances[msg.sender], amount );
		_balances[to] = add( _balances[to], amount );

		Transfer( msg.sender, to, amount );

		return true;
	}

	function 	transferFrom( address from, address to, uint amount ) returns ( bool ) {

		assert( _balances[from] >= amount );
		assert( _approvals[from][msg.sender] >= amount );

		_approvals[from][msg.sender] = sub( _approvals[from][msg.sender], amount );
		_balances[from] = sub( _balances[from], amount );
		_balances[to] = add( _balances[to], amount );

		Transfer( from, to, amount );

		return true;
	}

	function 	approve( address spender, uint256 amount ) returns ( bool ) {

		_approvals[msg.sender][spender] = amount;

		Approval( msg.sender, spender, amount );

		return true;
	}

}