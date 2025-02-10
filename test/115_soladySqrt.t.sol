// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

import {FixedPointMathLib} from "solady/src/utils/FixedPointMathLib.sol";

contract Test115 is Test, SymTest {
    function setUp() public {
        console2.log("Test115.setUp");
    }

    function test__SoladySqrt(uint128 i, uint128 n) public {
        vm.assume(n < i);
        uint x = uint (i) ** 2 + n;
        assertEq(FixedPointMathLib.sqrt(x), i);
    }
}
