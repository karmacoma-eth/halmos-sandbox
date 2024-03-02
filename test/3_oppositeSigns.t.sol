// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test3 is Test {
    function oppositeSignsSlow(int256 x, int256 y) internal pure returns (bool) {
        if (x >= 0 && y < 0) {
            return true;
        }

        if (x < 0 && y >= 0) {
            return true;
        }

        return false;
    }

    function oppositeSignsFast(int256 x, int256 y) internal pure returns (bool) {
        return (x ^ y) < 0;
    }

    function test_oppositeSigns(int256 x, int256 y) external {
        assertEq(oppositeSignsSlow(x, y), oppositeSignsFast(x, y));
    }
}
