// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

/// @custom:halmos --array-lengths someArray=128
contract Test53 is Test {
    function test_arrayLoopBound(bytes memory someArray) external {
        console2.log("someArray.length =", someArray.length);
    }
}
