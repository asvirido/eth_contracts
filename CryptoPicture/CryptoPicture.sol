
contract CryptoPicture {

	address				_admin;
	uint constant		_supply = 30;
	bytes32[supply] 	_cryptoPicture;
	bool[supply]		_noEmpty;

	mapping ( bytes32 => string ) 	_namePicture;
	mapping ( bytes32 => string ) 	_authorCryptoPicture;
	mapping ( bytes32 => bytes32 ) 	_hashPicture;
	mapping ( bytes32 => address ) 	_ownerCryptoPicture;
	
	event 	Transfer( address from, address to, bytes32 picture );

	function 	CryptoPicture() public {

		_admin = msg.sender;
	}

	modifier 	assertAdmin() {
		
		if ( msg.sender != _admin ) {
			assert( false );
		}
		_;
	}

	modifier 	assertOwnerPicture( uint id ) { 

		bytes32 hash;

		hash = _cryptoPicture[id];
		if ( msg.sender != _ownerCryptoPicture[picture] ) {
			assert( false );
		} 
		_;
	}

	function 	setAdmin( address admin ) public assertAdmin {

		_admin = admin;
	}
	

	function  	addPicture( uint id, string namePicture, bytes32 hashPicture, string author, address owner ) public assertAdmin {

		bytes32  hash;

		if ( id >= _supply || _noEmpty[id] == true )
			assert( false );

		hash = sha256( this, id, namePicture, hashPicture, author, owner );

		_cryptoPicture[id] = hash;
		_namePicture[hash] = name;
		_authorCryptoPicture[hash] = author;
		_ownerCryptoPicture[hash] = owner;
		_hashPicture[hash] = hashPicture;
		_noEmpty[id] = true;
	}

	function 	transfer( address to, uint id ) public assertOwnerPicture( id ) {
		
		bytes32 hash;

		hash = _cryptoPicture[id];

		_ownerCryptoPicture[hash] = to;
		Transfer( msg.sender, to, hash );
	}

	function 	getCryptoPicture( uint id ) public constant returns ( bytes32  hash ) {

		if ( id >= supply )
			assert( false );

		hash = _cryptoPicture[id];
	}
	

	function 	getTotalSupply() public constant returns ( uint supply )  {

		supply = _supply;
	}
	
	function 	getNamePicture( bytes32 picture ) public constant returns ( string name ) {
		
		name = _namePicture[picture];
	}

	function 	getAutorPicture( bytes32 picture ) public constant returns ( string autor ) {
		
		author = _authorCryptoPicture[picture];
	}
	
	function 	getHashPicture( bytes32 picture ) public constant returns ( bytes32 hash ) {
		
		hash = _hashPicture[picture];
	}

	function 	getOwnerPicture( bytes32 picture ) public constant returns ( address owner ) {
		
		owner = _ownerCryptoPicture[picture];
	}
}
