// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test49 is Test {
    function test_symbolicOffset(uint256 offset) external {
        uint256 x;
        assembly {
            x := mload(offset)
        }
        assert(x == 0);
    }
}
