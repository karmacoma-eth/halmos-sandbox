// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test120 is Test, SymTest {
    function setUp() public {
        console2.log("Test120.setUp");
    }

    function test_bytesEqual(bytes memory a, bytes memory b) external {
        vm.assume(keccak256(a) == keccak256(b));
        assertEq(a.length, b.length);
    }
}
