// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract Test24 is Test {
    constructor() {
        console.logBytes4(msg.sig);
    }

    function test_msgSig() external {
        assertEq(uint256(uint32(msg.sig)), 0x37b28889);
    }
}
