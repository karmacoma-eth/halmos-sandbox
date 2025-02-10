// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test114 is SymTest {
    uint8[] public uint8Array;

    function setUp() public {
        console2.log("Test114.setUp");
    }

    function test_uint8Array() external {
        uint8Array.push(1);
        uint8Array.push(2);
        uint8Array.push(3);

        assert(uint8Array[0] == 1);
        assert(uint8Array[1] == 2);
        assert(uint8Array[2] == 3);
    }
}
