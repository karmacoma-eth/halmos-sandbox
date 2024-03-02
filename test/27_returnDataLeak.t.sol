// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Returner {
    function foo() external pure returns (uint256) {
        return 42;
    }

    function bar() external view {
        Returner(address(this)).foo();

        assembly {
            // more efficient than return(0, 0)
            stop()
        }
    }
}

contract TestReturnData is Test {
    Returner ret;

    function setUp() public {
        ret = new Returner();
    }

    function test_returnDataLeak() external {
        ret.bar();

        uint256 s;
        assembly {
            s := returndatasize()
        }

        assertEq(s, 0);
        fail();
    }
}
