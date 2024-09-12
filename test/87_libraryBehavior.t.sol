// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

library SomeLibrary {
    function beep() public pure returns (uint256) {
        console2.log("boop");
        return 42;
    }
}

contract Test87 is Test, SymTest {
    function test_libraryBehavior() external {
        uint256 val = SomeLibrary.beep();
        assertEq(val, 42);
    }
}

