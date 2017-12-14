pragma solidity ^0.4.16;

contract ERC20Interface {

	// Get the total token supply
	function 	totalSupply() constant returns ( uint256 totalSupply );

	// Get the account balance of another account with address _owner
	function 	balanceOf( address _owner ) constant returns ( uint256 balance );

	// Send _value amount of tokens to address _to
	function 	transfer( address _to, uint256 _value ) returns ( bool success );

	// Send _value amount of tokens from address _from to address _to
	function 	transferFrom( address _from, address _to, uint256 _value ) returns ( bool success );

	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
	// If this function is called again it overwrites the current allowance with _value.
	// this function is required for some DEX functionality
	function 	approve( address _spender, uint256 _value ) returns ( bool success );

	// Returns the amount which _spender is still allowed to withdraw from _owner
	function 	allowance( address _owner, address _spender ) constant returns ( uint256 remaining );

	// Triggered when tokens are transferred.
	event 		Transfer( address indexed _from, address indexed _to, uint256 _value );

	// Triggered whenever approve(address _spender, uint256 _value) is called.
	event 		Approval( address indexed _owner, address indexed _spender, uint256 _value );
}


interface tokenRecipient{

	function receiveApproval( address _from, uint256 _value, address _token, bytes _extraData ) public;
}

contract TokenERC20 {

	string	public name;
	string	public symbol;
	uint256	public totalSupply;
	uint8	public decimals = 18;	// 18 decimals is the strongly suggested default, avoid changing it


	// This creates an array with all balances
	mapping ( address => uint256 ) public balanceOf;
	mapping ( address => mapping ( address => uint256 ) ) public allowance;

	// // This generates a public event on the blockchain that will notify clients
	// event Transfer( address indexed from, address indexed to, uint256 value );

	/**
	 * 	Initializes contract with initial supply tokens to the creator of the contract
	*/
	function 	TokenERC20( uint256 initialSupply, string tokenName, string tokenSymbol ) public {
		totalSupply = initialSupply * 10 ** uint256( decimals );	// Update total supply with the decimal amount
		balanceOf[msg.sender] = totalSupply;						// Give the creator all initial tokens
		name = tokenName;											// Set the name for display purposes
		symbol = tokenSymbol;										// Set the symbol for display purposes
	}

	/**
	* Internal transfer, only can be called by this contract
	*/
	function 	_transfer( address _from, address _to, uint _value ) internal {

		assert( _to != 0x0 ); // Prevent transfer to 0x0 address. Use burn() instead
		assert( balanceOf[_from] >= _value ); // Check if the sender has enough
		assert( balanceOf[_to] + _value > balanceOf[_to] ); // Check for overflows
		
		uint previousBalances = balanceOf[_from] + balanceOf[_to]; // Save this for an assertion in the future
		balanceOf[_from] -= _value; 		// Subtract from the sender
		
		balanceOf[_to] += _value; // Add the same to the recipient
		Transfer( _from, _to, _value );

		// Asserts are used to use static analysis to find bugs in your code. They should never fail
		assert( balanceOf[_from] + balanceOf[_to] == previousBalances );
	}

	/**
	* Transfer tokens
	*
	* Send `_value` tokens to `_to` from your account
	*
	* @param _to The address of the recipient
	* @param _value the amount to send
	*/
	function 	transfer( address _to, uint256 _value ) public {
		
		_transfer( msg.sender, _to, _value );
	}

	/**
	* Transfer tokens from other address
	*
	* Send `_value` tokens to `_to` in behalf of `_from`
	*
	* @param _from The address of the sender
	* @param _to The address of the recipient
	* @param _value the amount to send
	*/
	function 	transferFrom( address _from, address _to, uint256 _value ) public returns ( bool success ) {

		assert( _value <= allowance[_from][msg.sender] ); // Check allowance
		
		allowance[_from][msg.sender] -= _value;
		_transfer(_from, _to, _value);
		
		return true;
	}

	/**
	* Set allowance for other address
	*
	* Allows `_spender` to spend no more than `_value` tokens in your behalf
	*
	* @param _spender The address authorized to spend
	* @param _value the max amount they can spend
	*/

	function 	approve( address _spender, uint256 _value ) public returns ( bool success ) {
		
		allowance[msg.sender][_spender] = _value;
		
		return true;
	}

	/**
	* Set allowance for other address and notify
	*
	* Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
	*
	* @param _spender The address authorized to spend
	* @param _value the max amount they can spend
	* @param _extraData some extra information to send to the approved contract
	*/
	function 	approveAndCall( address _spender, uint256 _value, bytes _extraData ) public returns ( bool success ) {

		tokenRecipient spender = tokenRecipient( _spender );
		
		if ( approve( _spender, _value ) ) {
			spender.receiveApproval( msg.sender, _value, this, _extraData );
			return true;
		}
	}
}
