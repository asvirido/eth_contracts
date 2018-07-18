function dumpData(passportContractAddress, firstName, lastName, age, key) {
	var passportABI = [{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getUserLastName","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getUserId","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getUserFirstName","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"firstName","type":"string"},{"name":"lastName","type":"string"},{"name":"age","type":"uint8"}],"name":"registrationNewUseR","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getTrueUser","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"user","type":"address"}],"name":"getUserAge","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_amountId","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}];

	// var _passportContract = new web3.eth.contract(passportABI);

	// _passportContract.registrationNewUseR(firstName, lastName, age, function(error, result) {

	// });

	// currentContract = _passportContract.at('0x1f67893387b11c9be74782d1681e728ef359ea64');

	// return currentContract;

	var _passportContract = new web3.eth.contract(passportABI, passportContractAddress, {
			gas: 3000000,
		 gasPrice: "5000000000"
	});

	// return _passportContract;

	// return (_passportContract);
	// var encodedABI = _passportContract.registrationNewUseR(firstName, lastName, age).encodeABI();
	// var encodedABI = _passportContract.registrationNewUseR(firstName, lastName, age);
	return (_passportContract.at(passportContractAddress));
	// return _passportContract.at('0x1f67893387b11c9be74782d1681e728ef359ea64');

	// return currentContract.registrationNewUseR(firstName, lastName, age, function(result) {
	// 	console.log(result);
	// });
// 
	// return currentContract.registrationNewUseR(firstName, lastName, age, {
	// 	from: eth.accounts[0],
	// 	to: passportContractAddress,
	// 	gasPrice: "5000000000",
	// 	gas: "3000000",
	// 	value: "0",
	// 	data: registrationNewUseR(firstName, lastName, age).encodeABI()
	// });
	
	// var tx = {
	// 	from: eth.accounts[0],
	// 	to: passportContractAddress,
	// 	gasPrice: "5000000000",
	// 	gas: "3000000",
	// 	value: "0",
	// 	data: encodedABI
	// };

	// eth.accounts.signTransaction(tx, key);
	// .then(signed => {
	// 	var tran = web3.eth
	// 		.sendSignedTransaction(signed.rawTransaction)
	// 		.on('confirmation', (confirmationNumber, receipt) => {
	// 			console.log('=> confirmation: ' + confirmationNumber);
	// 		})
	// 		.on('transactionHash', hash => {
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

myContract.methods.myMethod(123).send({from: '0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe'}, function(error, transactionHash){

	tmp2.registrationNewUseR("a","b", 1, {from: eth.coinbase, gas: 1000000, value: web3.toWei(1, 'ether')});
