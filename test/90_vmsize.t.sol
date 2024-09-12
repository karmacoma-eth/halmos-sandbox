// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test90 is Test, SymTest {
    function setUp() public {
        console2.log("Test90.setUp");
    }

    function test_vmsize() external {
        address vmaddr = address(vm);
        uint256 size;
        bytes32 hash;
        assembly {
            size := extcodesize(vmaddr)
            hash := extcodehash(vmaddr)
        }

        console2.logBytes32(hash);

        assertEq(size, 0);
    }

    function test_precompiles() external {
        for (uint256 i = 0; i <= 0xa; i++) {
            address precompiled = address(uint160(i));
            uint256 size;
            assembly {
                size := extcodesize(precompiled)
            }

            assertEq(size, 0);
        }
    }
}
