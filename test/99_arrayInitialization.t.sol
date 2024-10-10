// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";


/// @dev what one may think the constructor does (unroll storage init + eliminate unecessary checks):

// revert if callvalue != 0
// SSTORE 3 at slot 0 (data.length = 3)
// compute keccak256(0) (data.slot)
// SSTORE 1 at data.slot + 1 (data[0] = 1)
// SSTORE 2 at data.slot + 2 (data[1] = 2)
// SSTORE 3 at data.slot + 3 (data[2] = 3)
// codecopy runtime bytecode to memory
// return runtime bytecode


/// @dev what the constructor actually does:

// set freeMemPointer to 0x80
// allocate memory for an array of 3 elements (freeMemPointer += 0x60)
// "clean" 1st value and store it in memory (array[0] = 1 & 0xff)
// "clean" 2nd value and store it in memory (array[1] = 2 & 0xff)
// "clean" 3rd value and store it in memory (array[2] = 3 & 0xff)
// SLOAD slot 0 (?)
// SSTORE 3 at slot 0 (data.length = 3)
// compute keccak256(0) (data.slot)

// i = 0
// while (1) {
//     memPointer = array + (i + 1) * 0x20
//     if (memPointer >= freeMemPointer) {
//         break
//     }
//     copy from memory to storage: SSTORE value (MLOAD(array[0]) & 0xff) at data.slot + i
//     i++
// }

// revert if data.slot + 2 < data.slot (?)
// revert if callvalue != 0
// codecopy runtime bytecode to memory
// return runtime bytecode

contract Test99 {
    uint256[] private data = [1, 2, 3];
}

// in order to debug Test99:
// forge debug Test99Deployer
// C to go to next call (CREATE)
contract Test99Deployer {
    function run() public {
        Test99 test99 = new Test99();
    }
}
