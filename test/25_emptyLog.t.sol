// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test25 is Test {
    event Log();

    function test_happyFestivus() external {
        emit Log();
    }
}
