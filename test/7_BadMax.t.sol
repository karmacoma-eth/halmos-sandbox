// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

/// @notice examples are from the talk "Program Synthesis: A Dream Realized?" by Roopsha Samanta
contract Test7 is Test {
    function badMax(uint256 x, uint256 y, uint256 z) public pure returns (uint256 max) {
        max = x;
        if (y < z) max = z;
        if (max < y) max = y;
    }

    function goodMax(uint256 x, uint256 y, uint256 z) public pure returns (uint256 max) {
        max = z;
        if (z <= y) max = y;
        if (max < x) max = x;
    }

    function assertMaxProperties(uint256 max, uint256 x, uint256 y, uint256 z) internal {
        assertTrue(max == x || max == y || max == z);
        assertGe(max, x);
        assertGe(max, y);
        assertGe(max, z);
    }

    function test_badMax(uint256 x, uint256 y, uint256 z) public {
        uint256 max = badMax(x, y, z);
        assertMaxProperties(max, x, y, z);
    }

    function test_goodMax(uint256 x, uint256 y, uint256 z) public {
        uint256 max = goodMax(x, y, z);
        assertMaxProperties(max, x, y, z);
    }
}
