pragma solidity ^0.4.18;

/*
* Interface ERC20
*/

contract Token {

	function transfer( address _to, uint256 _value ) public returns ( bool success );
	
	function transferFrom( address _from, address _to, uint256 _value ) public returns ( bool success );
	
	event Transfer( address indexed _from, address indexed _to, uint256 _value );

}