// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Dummy {}

contract Test9 is Test {
    function test_TestCreate2() external {
        Dummy d = new Dummy{salt: 0}();
    }
}
