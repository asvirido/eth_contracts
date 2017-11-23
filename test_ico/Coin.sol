
pragma solidity ^0.4.16;

contract Coin {
	
    address owner;
    mapping (address => uint) balances;

    event Transfer(address from, address to, uint value);
    
    function Coin() {
        owner = msg.sender;
    }

    modifier ownerValid() { 
    	if (msg.sender != owner) {
    		require(false);
    	}
    	_; 
    }

    modifier amountValid(uint amount) { 
    	if (amount == 0) {
    		require(false);
    	}
    	_; 
    }
    
    modifier balanceValid(address from, uint amount) { 
    	if (balances[from] < amount) {
    		require(false);
    	}
    	_;
    }
    
    // function fro add coin in balance owner
    function addNewCoin(uint amount) amountValid(amount) ownerValid {
        balances[owner] += amount;
    }

    function transfer(address receiver, uint amount) amountValid(amount) balanceValid(owner, amount) {
        balances[owner] -= amount;
        balances[receiver] += amount;
        Transfer(owner, receiver, amount);
    }

    function transferFrom (address from, address to, uint amount) amountValid(amount) balanceValid(from, amount){
    	balances[from] -= amount;
    	balances[to] += amount;
    	Transfer(from, to, amount);
    }
    
    function balanceOf(address account) constant returns (uint balance) {
        return balances[account];
    }
}