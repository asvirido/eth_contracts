interface IAdmin {
	function 	assertAdmin() private returns ( bool );
	function 	setAdmin( address admin )   private returns ( bool );
	function 	getAdmin() public constant returns( address admin );
}