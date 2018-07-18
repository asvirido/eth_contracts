/*
* for geth
*/

function test() {
	var i = 0;
	while (i < eth.accounts.length) {
		console.log(testPassport(eth.accounts[i]));
		i += 1;
	}
	return (true);
}

function testPassport(addressUser) {
	if (passportContract.getTrueUser(addressUser) == false) {
		return ("User " + addressUser + " doesn't exists in database");
	}
	var userFirstName = passportContract.getUserFirstName(addressUser);
	var userLastName = passportContract.getUserLastName(addressUser);
	var userId = passportContract.getUserId(addressUser);
	var userAge = passportContract.getUserAge(addressUser);

	console.log("User info " + addressUser);
	console.log("First Name = " + "[" + userFirstName + "]");
	console.log("Last Name = " + "[" + userLastName + "]");
	console.log("Age = " + "[" + userAge + "]");
	console.log("id  = " + "[" + userId + "]");
	return (1);
};