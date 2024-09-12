// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import {SSTORE2} from "solmate/utils/SSTORE2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test88 is Test, SymTest {
    function setUp() public {
        console2.log("Test88.setUp");
    }

    function test_symbolicSSTORE2() external {
        bytes memory data = svm.createBytes(1024, "data");
        address pointer = SSTORE2.write(data);
        bytes memory fetched = SSTORE2.read(pointer);
        assertEq(data, fetched);
    }
}
