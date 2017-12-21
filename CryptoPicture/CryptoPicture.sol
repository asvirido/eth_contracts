
contract CryptoPicture {

	address				_admin;
	uint constant		_supply = 30;
	bytes32[supply] 	_cryptoPicture;
	bool[supply]		_noEmpty;

	mapping ( bytes32 => string ) 	_namePicture;
	mapping ( bytes32 => string ) 	_authorCryptoPicture;
	mapping ( bytes32 => bytes32 ) 	_hashPicture;
	mapping ( bytes32 => address ) 	_ownerCryptoPicture;

	mapping ( address => mapping ( address => mapping ( bytes32 => bool ) ) ) 	_allowance;

	event 	Transfer( address from, address to, bytes32 picture );
	event 	Approval( address owner, address spender, bytes32 cryptoPicture, bool resolution );
	
	function 	CryptoPicture() public {

		_admin = msg.sender;
	}

	modifier 	assertAdmin() {
		
		if ( msg.sender != _admin ) {
			assert( false );
		}
		_;
	}

	modifier 	assertOwnerPicture( address owner, uint id ) { 

		bytes32 hash;

		assertId( id );
		hash = _cryptoPicture[id];
		if ( owner != _ownerCryptoPicture[picture] ) {
			assert( false );
		} 
		_;
	}

	function 	setAdmin( address admin ) public assertAdmin {

		_admin = admin;
	}
	

	function  	addPicture( uint id, string namePicture, bytes32 hashPicture, string author, address owner ) public assertAdmin {

		bytes32  hash;

		assertId( id );
		assertNoEmpty( id );

		hash = sha256( this, id, namePicture, hashPicture, author, owner );

		_cryptoPicture[id] = hash;
		_namePicture[hash] = name;
		_authorCryptoPicture[hash] = author;
		_ownerCryptoPicture[hash] = owner;
		_hashPicture[hash] = hashPicture;
		_noEmpty[id] = true;
	}

	function 	totalSupply() public constant returns ( uint supply )  {
		supply = _supply;
	}
	
	function 	allowance( address owner, address spender, uint id ) public constant returns ( bool ) {
		bytes32 	picture;
		
		assertId( id );
		picture = _cryptoPicture[id];
		return 	_allowance[owner][spender][picture];
	}

	function 	approve( address spender, uint id, bool resolution ) public assertOwnerPicture( msg.sender, id ) returns ( bool ) {
		bytes32 	hash;

		hash = _cryptoPicture[id];
		_allowance[msg.sender][spender][hash] = resolution;
		Approval( msg.sender, spender, hash, resolution );
		return true;
	}

	function 	transfer( address to, uint id ) public assertOwnerPicture( msg.sender, id ) returns ( bool ) {
		bytes32 hash;

		hash = _cryptoPicture[id];
		_ownerCryptoPicture[hash] = to;
		Transfer( msg.sender, to, hash );
		return true;
	}

	function 	transferFrom( address from, address to, uint id ) public assertOwnerPicture( from, id ) returns( bool ) {
		bytes32 	hash;

		hash = _cryptoPicture[id];
		if ( _allowance[from][msg.sender][hash] == false )
			assert( false );
		_ownerCryptoPicture[hash] = to;
		Transfer( from, to, hash );
		return true;
	}
	

	function 	getCryptoPicture( uint id ) public constant returns ( bytes32  hash ) {
		assertId( id );

		hash = _cryptoPicture[id];
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

	function 	assertId( uint id ) private {		
		if ( id >= _supply )
			assert( false );
	}

	function 	assertNoEmpty( uint id ) private {
		if (_noEmpty[id] == true )
			assert( false );
	}	
}
