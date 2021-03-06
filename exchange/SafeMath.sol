pragma solidity ^0.4.18;

contract SafeMath {

	function safeMul( uint a, uint b ) internal returns ( uint ) {
		
		uint 	c;
		
		c = a * b;
		assert( a == 0 || c / a == b );
		return c;
	}

	function safeSub( uint a, uint b ) internal returns ( uint ) {
		
		assert( b <= a );
		return a - b;
	}

	function safeAdd( uint a, uint b ) internal returns ( uint ) {
		
		uint 	c;
	
		c = a + b;
		assert( c >= a && c >= b );
		return c;
	}
}