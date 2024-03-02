// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract ReturnDataOOBTest {
    function test_returndataOutOfBounds() external pure {
        assembly {
            returndatacopy(0, 0, 1) // ❌ fails with EvmError: OutOfOffset
        }
    }
}
