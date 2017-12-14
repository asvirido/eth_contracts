contract Burn {
	
	// This notifies clients about the amount burnt
	event Burn( address indexed from, uint256 value );
	
	/**
	* Destroy tokens
	*
	* Remove `_value` tokens from the system irreversibly
	*
	* @param _value the amount of money to burn
	*/
	function 	burn( uint256 _value ) public returns ( bool success ) {
		
		assert( balanceOf[msg.sender] >= _value );	// Check if the sender has enough
		
		balanceOf[msg.sender] -= _value;			// Subtract from the sender
		totalSupply -= _value;						// Updates totalSupply
		Burn( msg.sender, _value );
		return true;
	}

	/**
	* Destroy tokens from other account
	*
	* Remove `_value` tokens from the system irreversibly on behalf of `_from`.
	*
	* @param _from the address of the sender
	* @param _value the amount of money to burn
	*/
	function 	burnFrom( address _from, uint256 _value ) public returns ( bool success ) {

		assert( balanceOf[_from] >= _value );					// Check if the targeted balance is enough
		assert( _value <= allowance[_from][msg.sender] );		// Check allowance

		balanceOf[_from] -= _value;							// Subtract from the targeted balance
		allowance[_from][msg.sender] -= _value;				// Subtract from the sender's allowance
		totalSupply -= _value;								// Update totalSupply
		Burn( _from, _value );
		return true;
	}
}
