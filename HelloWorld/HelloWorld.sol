pragma solidity ^0.4.15;
// https://habrahabr.ru/post/312008/
contract Owner {
    /*Для адресов есть отдельный тип переменных*/
    address owner;

    /*Данная функция исполняется лишь однажды - при загрузки контракта в блокчейн
    Называется также как и контракт
    Переменной owner присвоится значение адреса отправителя контракта, то есть ваш адрес*/
    function Owner(){
        owner = msg.sender;
    }

    /*Функция selfdestruct уничтожает контракт и отправляет все средства со счета контракта на адрес, указанный в аргументе*/
    /*В Ethereum любой участник сети может вызвать любую функцию
    Проверка адреса позволит уничтожить контракт только вам*/
    function kill() {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }
}

/*Оператор is отвечает за наследование*/
/*Возможно множественное наследование вида contract_1 is contract_2, contract_3*/
contract HelloWorld is Owner {
    string hello;
    string public constant name = "asvirido";
    /*В этом случае при инициализации контракта нужно будет указать строку-аргумент
    В нашем случае это и будет "Hello, world!"*/
    function HelloWorld(string _hello) public {
        hello = _hello;
    }

    // Эта функция и отвечает за возвращение "Hello, world!"
    function getHello() constant returns (string) {
        return hello;
    }
}