pragma solidity ^0.4.16;

contract CryptoPicture {

	address				_admin;
	uint constant		_supply = 29;
	uint 				_count;
	bytes32[_supply] 	_cryptoPicture;
	bool				_endEdit;

	mapping ( bytes32 => string ) 	_namePicture;
	mapping ( bytes32 => string ) 	_author;
	mapping ( bytes32 => bytes32 ) 	_hashPicture;
	mapping ( bytes32 => address ) 	_owner;
	mapping ( bytes32 => string ) 	_description;
	mapping ( address => mapping ( address => mapping ( bytes32 => bool ) ) ) 	_allowance;

	event 	Transfer( address from, address to, bytes32 picture );
	event 	Approval( address owner, address spender, bytes32 cryptoPicture, bool resolution );

	function 	CryptoPicture() public {
		_admin = msg.sender;
	}

	/*** Assert  functions ***/
	function 	assertAdmin() private {
		if ( msg.sender != _admin ) {
			assert( false );
		}
	}

	function 	assertOwnerPicture( address owner, bytes32 hash ) private {
		if ( owner != _owner[hash] ) {
			assert( false );
		}
	}

	function 	assertId( uint id ) private {
		if ( id >= _supply )
			assert( false );
	}

	function 	assertAllowance(address from, bytes32 hash) private {
		if ( _allowance[from][msg.sender][hash] == false )
			assert( false );
	}

	function 	assertEdit() public {
		if ( _endEdit == true )
			assert( false );
	}

	function 	assertCount() public {
		if ( _count >= _supply )
			assert( false );
	}

	/*** Admin panel ***/
	function  	addPicture( string namePicture, bytes32 hashPicture, string author, address owner, string description ) public {
		assertAdmin();
		assertCount();

		setPicture(_count, namePicture, hashPicture, author, owner, description);
		_count++;
	}

	function	setEndEdit() public {
		assertAdmin();
		_endEdit = true;
	}

	function 	setAdmin( address admin ) public {
		assertAdmin();
		_admin = admin;
	}

	/*** Edit function for Admin ***/
	function 	setNamePiture( uint id, string namePicture ) public {
		bytes32 	hash;

		assertProtectedEdit( id );

		hash = _cryptoPicture[id];
		setPicture( id, namePicture, _hashPicture[hash], _author[hash], _owner[hash], _description[hash] );
	}

	function 	setAuthor( uint id, string author ) public {
		bytes32 	hash;

		assertProtectedEdit( id );

		hash = _cryptoPicture[id];
		setPicture( id, _namePicture[hash], _hashPicture[hash], author, _owner[hash], _description[hash] );
	}

	function 		setDescription( uint id, string description ) public {
		bytes32 	hash;

		assertProtectedEdit( id );

		hash = _cryptoPicture[id];
		setPicture( id, _namePicture[hash], _hashPicture[hash], _author[hash], _owner[hash], description );
	}

	function 		setHashPiture( uint id, bytes32 hashPicture ) public {
		bytes32 	hash;

		assertProtectedEdit( id );

		hash = _cryptoPicture[id];
		setPicture( id, _namePicture[hash], hashPicture, _author[hash], _owner[hash], _description[hash] );
	}

	function 		setOwner( uint id, address owner ) public {
		bytes32 	hash;

		assertProtectedEdit( id );

		hash = _cryptoPicture[id];
		setPicture( id, _namePicture[hash], _hashPicture[hash], _author[hash], owner, _description[hash] );
	}

	/*** private function for edit field cryptoPicture	***/
	function	assertProtectedEdit( uint id ) private {
		assertAdmin();
		assertEdit();
		assertId( id );
	}

	function 	setPicture( uint id, string namePicture, bytes32 hashPicture, string author, address owner, string description ) private {
		bytes32 	hash;

		hash = sha256( this, id, namePicture, hashPicture, author, owner, description );

		_cryptoPicture[id] = hash;
		_namePicture[hash] = namePicture;
		_author[hash] = author;
		_owner[hash] = owner;
		_hashPicture[hash] = hashPicture;
		_description[hash] = description;
	}

	/*** ERC20 similary ***/
	function 	totalSupply() public constant returns ( uint supply )  {
		supply = _supply;
	}

	function 	allowance( address owner, address spender, bytes32 picture) public constant returns ( bool ) {
		return 	_allowance[owner][spender][picture];
	}

	function 	approve( address spender, bytes32 hash, bool resolution ) public returns ( bool ) {
		assertOwnerPicture( msg.sender, hash );

		_allowance[msg.sender][spender][hash] = resolution;
		Approval( msg.sender, spender, hash, resolution );
		return true;
	}

	function 	transfer( address to, bytes32 hash ) public returns ( bool ) {
		assertOwnerPicture( msg.sender, hash );

		_owner[hash] = to;
		Transfer( msg.sender, to, hash );
		return true;
	}

	function 	transferFrom( address from, address to, bytes32 hash ) public returns( bool ) {
		assertOwnerPicture( from, hash );
		assertAllowance( from, hash );

		_owner[hash] = to;
		_allowance[from][msg.sender][hash] = false;
		Transfer( from, to, hash );
		return true;
	}

	/*** Get variable ***/
	function 	getCryptoPicture( uint id ) public constant returns ( bytes32  hash ) {
		assertId( id );

		hash = _cryptoPicture[id];
	}

	function 	getNamePicture( bytes32 picture ) public constant returns ( string name ) {
		name = _namePicture[picture];
	}

	function 	getAutorPicture( bytes32 picture ) public constant returns ( string author ) {
		author = _author[picture];
	}

	function 	getDescription( bytes32 picture ) public constant returns ( string description ) {
		description = _description[picture];
	}

	function 	getHashPicture( bytes32 picture ) public constant returns ( bytes32 hash ) {
		hash = _hashPicture[picture];
	}

	function 	getOwnerPicture( bytes32 picture ) public constant returns ( address owner ) {
		owner = _owner[picture];
	}
}
