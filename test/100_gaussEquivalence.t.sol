// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

// from https://runtimeverification.com/blog/formally-verifying-loops-part-1
contract Test100 is Test, SymTest {
    function setUp() public {
        console2.log("Test100.setUp");
    }

    function sumToN(uint256 n) public pure returns (uint256) {
        uint256 result = 0;
        uint256 i = 0;
        while (i < n) {
            unchecked {
                i = i + 1;
                result = result + i;
            }
        }
        return result;
    }

    function triangleNumber(uint256 n) public pure returns (uint256) {
        return n * (n + 1) / 2;
    }

    function check_gaussEquivalence(uint256 n) public pure {
        // vm.assume(n < 2**128); // prevent overflow
        assertEq(sumToN(n), triangleNumber(n));
    }
}
