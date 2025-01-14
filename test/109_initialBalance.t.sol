// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract SomeContract {}

contract Test109 is Test, SymTest {
    SomeContract target;

    function setUp() public {
        console2.log("Test109.setUp");
        target = new SomeContract();
    }

    function test_initialBalance() external {
        console2.log("initial balance:", address(target).balance);
    }
}
