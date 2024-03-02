// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Callee {
    function foo() external payable {
        assert(false);
    }
}

contract Caller {
    function callFoo(address callee) external returns (bool) {
        (bool success,) = callee.call(abi.encodeWithSignature("foo()"));
        return success;
    }
}

contract Test22 is Test {
    function test_assertInSubContext() external {
        Callee callee = new Callee();
        Caller caller = new Caller();

        assertEq(caller.callFoo(address(callee)), false);
    }
}
