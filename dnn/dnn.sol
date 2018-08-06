pragma solidity ^0.4.24;

contract Admin {

	address private _admin;

	constructor (address admin) public {
		_admin = admin;
	}

	function 	assertAdmin() internal view returns (bool) {
		if (_admin != msg.sender)
			revert();
		return true;
	}

	function 	setAdmin(address admin) public returns (bool) {
		assertAdmin();

		_admin = admin;
		return true;
	}

	function 	getAdmin() public constant returns(address admin) {
		return 	_admin;
	}
}


contract DNN is Admin {
	uint private _sizeModerator = 3;
	
	event AddArticle(bytes32 hash);
	
	struct Editor {
		int rateEditor;
		int amountArticle;
	}

	struct Article {
		address userEditor;
		address[3] moderators;
		uint8[3] voteStateModerator;
		uint rateArticle;
		bool approve;
		string topic; 
		uint deadlineVoting;
	}

	struct  Moderator {
		bool state;
		int rateModerator;
		string topic;
	}
	
	mapping(address => Moderator) public listModerators;
	mapping(bytes32 => Article) public listArticle;
	mapping(address => Editor) public listEditor;

	constructor () Admin(msg.sender) public{
		listModerators[msg.sender].state = true;
		listModerators[0xb8C28dA2363e51200239cAe6911D58abEd2760AE].state = true;
		listModerators[0x709953892121a4a027EEED55020Ed8A67A707CEA].state = true;
		// listModerators[0x6B10be66055ac5922b0d3dF1f54d76BE5bEfa8A4].state = true;
		// listModerators[0xd23900bd6be4E98c3e2C49c859E89955A7B60EC5].state = true;
	}

	// function 	depositEth(bytes32 hash) public payable {
		// uint amount;

		// assertQuantity( msg.value );
		// amount = msg.value;
		// msg.sender.transfer(amount);
	// }

	function   createArticle(bytes32 _hash, string _topic) public {
		if (listArticle[_hash].userEditor != 0x0) {
			revert();
		}
		address[3] 	memory moderators;
		uint8[3]	memory stateVote;

		Article memory article = Article(
			msg.sender,
			moderators,
			stateVote,
			0,
			false,
			_topic,
			0);
		listArticle[_hash] = article;
		emit AddArticle(_hash);
	}

	/*
	**	Function for Admin.
	*/
	function 	setModerators(bytes32 _hash,
				address moderator1,
				address moderator2,
				address moderator3,
				address moderator4,
				address moderator5) public {
		assertAdmin();
		
		listArticle[_hash].moderators[0] = moderator1;
		listArticle[_hash].moderators[1] = moderator2;
		listArticle[_hash].moderators[2] = moderator3;
		// listArticle[_hash].moderators[3] = moderator4;
		// listArticle[_hash].moderators[4] = moderator5;
	}
	/*
	** Function for Admin.
	*/
	function 	setModerator(bytes32 _hash, uint id, address moderator) public {
		assertAdmin();

		if (id >= _sizeModerator) {
			revert();
		}
		if (listArticle[_hash].approve == true) {
			revert();
		}
		if (listArticle[_hash].voteStateModerator[id] != 0){
			revert();
		}
		if (now <= listArticle[_hash].deadlineVoting) {
			revert();
		}
		if (listArticle[_hash].moderators[id] != 0x0) {
			revert();
		}

		listArticle[_hash].moderators[id] = moderator;
	}

	/*
	** (state = 1)== no
	** (state = 2)== yes
	*/
	function    voting(uint8 state, bytes32 hash) public {
		uint    i = 0;

		if (listModerators[msg.sender].state == false) {
			revert();
		}

		if (listArticle[hash].approve == true) {
			revert();
		}

		if (listArticle[hash].rateArticle != 0) {
			revert();
		}

		if (state != 1 && state != 2) {
			revert();
		}

		while (i < _sizeModerator) {
			if (listArticle[hash].moderators[i] == msg.sender) {
				break ;
			}
			if (i == _sizeModerator - 1) {
				revert();
			}
			i += 1;
		}

		listArticle[hash].voteStateModerator[i] = state;
		i = 0;
		uint count = 0;

		uint sizeApprove = 2; // start with zero

		while (i < _sizeModerator) {
			if (listArticle[hash].voteStateModerator[i] != 0) {
				count += 1;
			}
			i += 1;
		}
		if (count >= sizeApprove) { // approve yes or no
			listArticle[hash].approve = true;
			listArticle[hash].rateArticle = count;
			i = 0;

			// for rate change
			if (listArticle[hash].approve == true) {
				listEditor[listArticle[hash].userEditor].rateEditor += 1; 
				listEditor[listArticle[hash].userEditor].amountArticle += 1;
				while (i < _sizeModerator) {
					listModerators[listArticle[hash].moderators[i]].rateModerator += 1;
					i += 1;
				}
			}
			else {
				listEditor[listArticle[hash].userEditor].rateEditor -= 1; 
				while (i < _sizeModerator) {
					listModerators[listArticle[hash].moderators[i]].rateModerator -= 1;
					i += 1;
				}
			}
		}
	}
	
	function getAmountVote(bytes32 hash) view public returns(uint256) {
		uint i = 0;
		
		uint count = 0;
		while (i < _sizeModerator) {
			if (listArticle[hash].voteStateModerator[i] != 0) {
				count += 1;
			}
			i += 1;
		}
		return (count);
	}
	
	function getStateVoteModerator(bytes32 hash, address moderator) view public returns(uint8) {
		uint i = 0;
		
		while (i < _sizeModerator) {
			if (listArticle[hash].moderators[i] == moderator) {
				return (listArticle[hash].voteStateModerator[i]);
			}
			i += 1;
		}
		return (3);
	}

	function getArrayAddressModerator(bytes32 hash) public view returns(address[5]){
		return (listArticle[hash].moderators);
	}

	function getArrayVoteModerator(bytes32 hash) public view returns(uint8[5]){
		return (listArticle[hash].voteStateModerator);
	} 

	function  changeNotActiveModeratorForArticle(bytes32 _hash, address userModerator) public {
		if (now <= listArticle[_hash].deadlineVoting) {
			revert();
		}

		if (msg.sender != listArticle[_hash].userEditor) {
			revert();	
		}

		uint i = 0;
		while (i < _sizeModerator) {
			if (listArticle[_hash].moderators[i] == userModerator) {
				if (listArticle[_hash].voteStateModerator[i] == 0) {
					listArticle[_hash].moderators[i] = 0x0;
					listModerators[userModerator].rateModerator -= 2;
					break ;
				}
			}
			i += 1;
		}
	}
	
	// создание нового модератора
	// редактор после нескольких статей и других параметров
	// может подать запрос на то чтобы стать новым модератором по конкретной теме
	// существующие модераторы голосуют за то чтобы пользователь стал модератором или нет
	function 	createModerator(address) public {
		if (listEditor[msg.sender].amountArticle > 1) {
			listModerators[msg.sender].state = true;
		}
	}

	// function 	assertQuantity( uint amount ) private pure {
	// 	if ( amount == 0 ) {
	// 		require( false );
	// 	}
	// }
}