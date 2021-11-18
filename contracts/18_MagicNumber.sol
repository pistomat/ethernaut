// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// solver bytecode is 0x660EA5eFB4dC6a412B9FE5d678DDC8AA7512B571 
// pseudo assembly
// dataSize(sub_0)
// dup1
// dataOffset(sub_0)
// 0x00
// codecopy
// 0x00
// return
// sub_0: assembly {
//     mstore(0x80, 0x42)
//     return(0x80, 0x20)
// }


contract MagicNum {

  address public solver;

  constructor() public {}

  function setSolver(address _solver) public {
    solver = _solver;
  }

  /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
  */
}