pragma solidity ^0.4.15;

contract StringHolder {

	string globalText;

	function setGlobalText(string _text) {
		globalText = _text;
	}

	function getGlobalText() constant returns (string) {
		return globalText;
	}
	
}
