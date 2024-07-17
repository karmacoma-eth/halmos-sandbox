// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test60 is Test, SymTest {
    /// @custom:halmos --loop 12
    function test_manyCexes() external {
        for(uint256 i = 1; i <= 12; ++i) {
            uint256 y = svm.createUint256("y");
            uint256 z = svm.createUint256("z");
            assertNotEq(y * z, 1 << i);
        }
    }
}









