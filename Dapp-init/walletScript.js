var sizeWallet = 10;
if (web3.eth.accounts.length < sizeWallet) {
	var i = web3.eth.accounts.length;
	while (i < sizeWallet) {
		personal.newAccount(i.toString());
		i += 1;
	}
}

function unlockWallet() {
	var i = 0;
	while (i < sizeWallet) {
		console.log("unlock account " + eth.accounts[i] + " is " + web3.personal.unlockAccount(eth.accounts[i], i.toString()));
		i += 1;
	}
	return (true);
}

miner.setEtherbase(eth.accounts[0])