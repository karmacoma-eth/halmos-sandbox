// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test92 is Test, SymTest {
    function setUp() public {
        console2.log("Test92.setUp");
    }

    // 1. you don't want to use bound()
    // 2. you especially don't want to combine multiple bound() calls
    //
    // [PASS] test_bound(uint256,uint256,uint256) (paths: 318, time: 5.40s (paths: 5.40s, models: 0.00s), bounds: [])
    function test_bound(uint256 x, uint256 y, uint256 z) external pure {
        x = bound(x, 2, 4);
        y = bound(y, 4, 8);
        z = bound(z, 8, 16);
    }
}
