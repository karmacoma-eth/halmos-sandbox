// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";

contract MathTest is Test {
    function check_percentMulLt(uint256 amount) public {
        vm.assume(amount < type(uint128).max);
        uint256 percent = 5_000;
        uint256 result = percentMul(amount, percent);
        assertLe(result, amount);
    }

    function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256) {
        return ((value * percentage)) / 1e4;
    }
}
