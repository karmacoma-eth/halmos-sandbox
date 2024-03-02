// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test32 is Test {
    function test_distributivity_lhs_rhs_uint120(uint120 x, uint120 y, uint120 z) public {
        uint120 lhs = x * (y + z);
        uint120 rhs = (x * y) + (x * z);
        assertEq(lhs, rhs);
    }

    function test_distributivity_lhs_rhs_uint256(uint120 x, uint120 y, uint120 z) public {
        uint256 lhs = x * (y + z);
        uint256 rhs = (x * y) + (x * z);
        assertEq(lhs, rhs);
    }

    function f(uint120 x, uint120 y, uint120 z) public pure returns (bool) {
        return x + (y * z) == (x + y) * (x + z);
    }

    function test_distributivity_msoos(uint120 x, uint120 y, uint120 z) public pure {
        assert(x + (y * z) == (x + y) * (x + z));
    }

    function test_distributivity_msoos_fixed(uint120 x, uint120 y, uint120 z) public {
        assertTrue((x * (y + z)) == ((x * y) + (x * z)));
    }
}
