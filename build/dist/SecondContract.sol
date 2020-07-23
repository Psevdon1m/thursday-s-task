pragma solidity ^0.5.10;


library IterableMapping {
    // Iterable mapping from address to uint;
    struct Map {
        address[] keys;
        mapping(address => uint256) values;
        mapping(address => uint256) indexOf;
        mapping(address => bool) inserted;
    }

    function get(Map storage map, address key) public view returns (uint256) {
        return map.values[key];
    }

    function getKeyAtIndex(Map storage map, uint256 index)
        public
        view
        returns (address)
    {
        return map.keys[index];
    }

    function size(Map storage map) public view returns (uint256) {
        return map.keys.length;
    }

    function set(
        Map storage map,
        address key,
        uint256 val
    ) public {
        if (map.inserted[key]) {
            map.values[key] = val;
        } else {
            map.inserted[key] = true;
            map.values[key] = val;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }

    function remove(Map storage map, address key) public {
        if (!map.inserted[key]) {
            return;
        }

        delete map.inserted[key];
        delete map.values[key];

        uint256 index = map.indexOf[key];
        uint256 lastIndex = map.keys.length - 1;
        address lastKey = map.keys[lastIndex];

        map.indexOf[lastKey] = index;
        delete map.indexOf[key];

        map.keys[index] = lastKey;
        map.keys.pop();
    }
}

contract FirstContract {
    using IterableMapping for IterableMapping.Map;

    IterableMapping.Map private map;

    struct Book {
        string title;
        uint256 price;
    }
    struct Person {
        uint256 balance;
        uint256[] personsBooks;
    }

    address public owner;
    Book[] public books;

    mapping(address => Person) public persons;

    event Deposit(address indexed addr, uint256 amount);
    event Withdrawal(address indexed addr, uint256 amount);
    event BuyBook(address indexed addr, uint256 book);

    modifier onlyOwner() {
        require(msg.sender == owner, "Access denied");
        _;
    }

    constructor() public {
        owner = msg.sender;

        books.push(Book({title: "Book A", price: 3000000}));
        books.push(Book({title: "Book B", price: 5000000}));
        books.push(Book({title: "Book C", price: 8000000}));
        books.push(Book({title: "Book D", price: 12000000}));
        books.push(Book({title: "Book E", price: 15000000}));
    }

    function() external payable {
        deposit(msg.sender, msg.value);
    }

    function deposit(address addr, uint256 _amount) private {
        require(_amount > 0, "Please deposit more funds");
        // persons[msg.sender].addr = msg.sender;
        persons[addr].balance += _amount;

        emit Deposit(msg.sender, _amount);
    }

    function buyBook(address addr, uint256 _bookIndex) public payable {
        Person storage person = persons[addr];
        require(_bookIndex <= 4, "Book not found, try 0-4");
        require(
            person.balance >= books[_bookIndex].price,
            "You do not have enogh funds"
        );

        person.balance -= books[_bookIndex].price;
        person.personsBooks.push(_bookIndex);
        map.set(addr, _bookIndex);

        emit BuyBook(addr, _bookIndex);
    }

    function sellBook(address payable addr, uint256 _bookIndex) public {
        require(
            persons[addr].personsBooks.length > 0,
            "You do not have any books to sell"
        );
        require(
            persons[addr].personsBooks[_bookIndex] <= 4,
            "You do not have such book"
        );
        require(map.get(addr) == _bookIndex, "You do not have this book");

        Person storage person = persons[addr];
        uint256 bookToRemove = map.get(addr);
        removeBook(addr, bookToRemove);

        person.balance += books[_bookIndex].price;
        sendFunds(addr, person.balance);
    }

    function removeBook(address addr, uint256 index)
        public
        returns (uint256[] memory)
    {
        Person storage person = persons[addr];
        for (uint256 i = index; i < person.personsBooks.length - 1; i++) {
            person.personsBooks[i] = person.personsBooks[i + 1];
        }
        delete person.personsBooks[person.personsBooks.length - 1];
        person.personsBooks.length--;
        return person.personsBooks;
    }

    function sendFunds(address payable addr, uint256 amount) public payable {
        Person storage person = persons[addr];
        person.balance -= amount;
        addr.transfer(amount);
    }
}

contract SecondContract {}