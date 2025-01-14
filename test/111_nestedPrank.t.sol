// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test111 is Test, SymTest {
    function setUp() public {
        console2.log("Test111.setUp");
        // vm.startPrank(address(0));
        // vm.startPrank(address(0));
    }

    function test_nestedPrank() external {
        vm.startPrank(address(0));
        vm.startPrank(address(0));
    }
}
