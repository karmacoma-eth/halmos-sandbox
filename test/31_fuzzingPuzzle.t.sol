// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract CubeTest is Test {
    function test_fuzzingPuzzle(uint256 v) external {
        unchecked {
            assertNotEq(v * v * v, 1881672302290562263);
        }
    }
}
