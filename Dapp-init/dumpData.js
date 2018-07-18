function dumpData(passportContractAddress, firstName, lastName, age, key) {
	var passportABI = [{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getUserLastName","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getUserId","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getUserFirstName","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"firstName","type":"string"},{"name":"lastName","type":"string"},{"name":"age","type":"uint8"}],"name":"registrationNewUseR","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getTrueUser","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getUserAge","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_amountId","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}];

	var passportContract = new web3.eth.contract(passportABI);

	var contractInstance = passportContract.at(passportContractAddress);
	
	var encodedABI = contractInstance.registrationNewUseR(firstName, lastName, age).encodeABI();
	
	var tx = {
		from: eth.accounts[0],
		to: passportContractAddress,
		gasPrice: "5000000000",
		gas: "3000000",
		value: "0",
		data: encodedABI
	};

	// eth.accounts.signTransaction(tx, key);
	// .then(signed => {
	// var tran = web3.eth.sendSignedTransaction(signed.rawTransaction);
			// .on('confirmation', (confirmationNumber, receipt) => {
				// console.log('=> confirmation: ' + confirmationNumber);
	// 		// })
	// 		// .on('transactionHash', hash => {
	// 			console.log('=> hash');
	// 			console.log(hash);
	// 		})
	// 		.on('receipt', receipt => {
	// 			console.log('=> reciept');
	// 			console.log(receipt);
	// 		})
	// 		.on('error', console.error);
	// });
	
}