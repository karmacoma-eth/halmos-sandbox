// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test34 is Test {
    function test_emptyLog() external {
        assembly {
            log0(0, 0)
        }
    }
}
