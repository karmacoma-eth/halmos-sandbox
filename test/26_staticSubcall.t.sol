// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Foo {
    uint256 x;

    function do_sstore() public returns (uint256) {
        unchecked {
            x += 1;
        }
        return x;
    }

    function test_staticcall_actually_writes() public view returns (bool success) {
        (success,) = address(this).staticcall(abi.encodeWithSignature("do_sstore()"));
        assert(success);
    }
}
