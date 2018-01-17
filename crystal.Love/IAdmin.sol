pragma solidity ^0.4.18;

contract IAdmin {
	function 	assertAdmin() private returns ( bool );
	function 	getAdmin() public constant returns( address admin );

}
