// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract TestManager {
    event log0(address testAddress);
    event log1(string testString);

    struct User {
        address[] tests;
    }
    mapping(address => User) private users;//здесь хранятся задачи каждого пользователя

    address[] private tests;// все активные задачи
    address[] private complTests; // все завершенные задачи
    
    function createTest(string memory _imageLink1, 
                        string memory _imageLink2,
                        string memory _imageLink3,
                        string memory _imageLink4,
                        uint _requiredVotes
                        ) public {
        // Создание нового контракта ImageTest 
        ImageTest newTest = new ImageTest(  _imageLink1, 
                                            _imageLink2, 
                                            _imageLink3, 
                                            _imageLink4, 
                                            _requiredVotes);
        
        // Добавление адреса нового теста в список активных тестов 
        tests.push(address(newTest));
        // Добавили к пользователю его задачи
        if (users[msg.sender].tests.length == 0) {  
            users[msg.sender] = User({ tests: new address[](0) });  
        }
        users[msg.sender].tests.push(address(newTest));         
    }

    function getTest() public returns (address, string memory, string memory, string memory, string memory){
        address testAddr = getTestPrivate();
        
        if (testAddr !=address(0) ){
            ImageTest testImage = ImageTest(testAddr);
            
//            console.log(testAddr, testImage.imageLinks(0)); 
            emit log0( testAddr );
            emit log1( testImage.imageLinks(0));
            emit log1( testImage.imageLinks(1));
            emit log1( testImage.imageLinks(2));
            emit log1( testImage.imageLinks(3));

            return (testAddr, 
                testImage.imageLinks(0),
                testImage.imageLinks(1), 
                testImage.imageLinks(2), 
                testImage.imageLinks(3) );
            
        } 
        return (address(0), '', '', '', '');
    }

    //функция голосования сразу же возвращает следующий тест, чтобы не тратить лишнюю транзакцию
    function setVote(address _addr, uint _numImage ) public {
     
        if (_addr !=address(0) ){
            ImageTest testImage = ImageTest(_addr);
            testImage.vote(_numImage);
        }
    }

//Здесь мы получаем следующий тест
    function getTestPrivate() private returns (address) {
        //каждый раз при запросе функции проверяем все активные тесты на завершенность
        uint256[] memory indexes = new uint256[](tests.length);        
        uint256 k = 0;
        
        for (uint256 i = 0; i < tests.length; i++){
            ImageTest testImage = ImageTest(tests[i]); // declare and define a new instance of ImageTest
            
            if  ( testImage.isDone() )  {  
                k++;
                complTests.push( tests[i] );
                indexes[k] = i;
            }

        }        
        
        //удаляем тесты из массива с сохранением индексации
        if ( k > 0 ){
            for (uint256 i = (k - 1); i >= 0; i--){
                for (uint256 j = i; j < tests.length ; j++){
                    tests[j] = tests[j - 1]; // Перемещаем все тесты, кроме текущего, на один влево в массив
                }
                tests.pop();
            }            
        }

        if (tests.length>0){ 
            return tests[0];
        } 
        else 
            return address(0);
    }
    
}

contract ImageTest {
    struct User {
        uint vote;
    }
    
    mapping(address => User) public users;
    address[] public voters;
    uint[] public imageVotes;
    string[] public imageLinks;
    uint public requiredVotes;
    uint public recVotes = 0;
    bool public isActive = true;
    bool public isDone = false;
    
    constructor(string memory _imageLink1, 
                string memory _imageLink2, 
                string memory _imageLink3, 
                string memory _imageLink4, 
                uint _requiredVotes) payable {
        imageLinks.push(_imageLink1);
        imageLinks.push(_imageLink2);
        imageLinks.push(_imageLink3);
        imageLinks.push(_imageLink4);

        requiredVotes = _requiredVotes;  // Количество необходимых голосов для победы
    }
    
    function vote(uint imageIndex) public payable {
        require(!hasVoted(), "You have already voted");
        
        if (imageIndex >= 0 && imageIndex <= 3) {
            users[msg.sender].vote = imageIndex;
            voters.push(msg.sender);

            imageVotes[imageIndex] ++;
            recVotes ++;

            if (recVotes >= requiredVotes) {
                isDone = true;
            }                
// Вознаграждение создателю теста за свой голос
//            payable(msg.sender).transfer(0.01 ether); 
        } else {
            revert("Invalid image index");
        }
    }
    
    function hasVoted() public view returns (bool) {
        for(uint i=0; i<voters.length; i++){
            if(voters[i] == msg.sender){
                return true;
            }
        }
        
        return false;
    }
}
