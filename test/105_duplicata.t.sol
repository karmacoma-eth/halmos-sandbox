// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test105 is Test, SymTest {
    function setUp() public pure {
        console2.log("Test105.setUp");
    }

    function test_duplicata1(uint256 x) external pure {
        uint256 mul = x * 42;
        assertNotEq(mul, 0);
        assertNotEq(mul, 0);
        assertNotEq(mul, 0);
    }

    function test_duplicata2(uint256 x) external pure {
        uint256 acc = 0;

        unchecked {
            // just introduce some extra paths
            acc += (x & (0xFF << 8) > 0) ? 2 : 3;
            acc += (x & (0xFF << 16) > 0) ? 5 : 3;

            assertNotEq((x & 0xff) * uint256(acc), 0);
        }
    }

    function test_duplicata3(uint256 x) external pure {
        assertNotEq(x, 0);
        assertNotEq(x & 0xff, 0);
        assertNotEq(x & 0xff << 8, 0);
    }
}
