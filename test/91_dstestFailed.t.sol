// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract Test91 is Test {
    function test_dstestFailed() external {
        console2.log("failed() =", failed());
    }
}
