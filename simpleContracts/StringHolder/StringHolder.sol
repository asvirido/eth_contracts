pragma solidity ^0.4.18;

contract StringHolder {

	string globalText;

	function 	setGlobalText(string _text) public {
		globalText = _text;
	}

	function 	getGlobalText() public constant returns ( string ) {
		return globalText;
	}

}
