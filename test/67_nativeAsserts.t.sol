// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test67 is Test {
    function solAssertEq(uint256 a, uint256 b) internal {
        if (a != b) {
            console.log("assertion failed: ", a, " != ", b);
            fail();
        }
    }

    function solAssertTrue(bool a) internal {
        if (!a) {
            console.log("assertion failed: ", a);
            fail();
        }
    }

    function test_asserts_native() external {
        console.log("we're going to vm.assert some stuff");
        uint256 a = 1;
        // vm.assertEq(a, 2);
        // vm.assertTrue(false);
        console.log("Is this printed?");
    }

    function test_asserts_std() external {
        console.log("we're going to assert some stuff");
        uint256 a = 1;
        solAssertEq(a, 2);
        solAssertTrue(false);
        console.log("Is this printed?");
    }
}
