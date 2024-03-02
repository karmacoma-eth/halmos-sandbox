// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test41 is Test {
    function test_valueView() external view {
        // can not access msg.value in view func
        // console2.log("msg value", msg.value);
    }
}
