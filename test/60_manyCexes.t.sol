// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test60 is Test {
    function test_manyCexes(uint256 x) external {
        uint256 i = 0;
        if (x & 1 == 0) ++i;
        if (x & 2 == 0) ++i;
        if (x & 4 == 0) ++i;
        if (x & 8 == 0) ++i;

        assert(x < 64);
    }
}









