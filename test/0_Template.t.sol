// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract TestX is Test, SymTest {
    function setUp() public {
        console2.log("TestX.setUp");
    }

    function test_X() external {}
}
