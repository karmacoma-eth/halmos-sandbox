// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test117 is Test, SymTest {
    function setUp() public {
        console2.log("Test117.setUp");
    }

    function test_shiftByBool(uint256 x) external {
        uint256 y;
        assembly {
            let cond := eq(x, 42)
            y := shr(x, cond)
        }
        assertNotEq(y, 42);
    }
}
