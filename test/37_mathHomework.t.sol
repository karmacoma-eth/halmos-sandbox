// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract Test37 is Test {
    function test_mathHomework(uint8 hundreds, uint8 tens, uint8 units) external {
        unchecked {
            vm.assume(hundreds < 10);
            vm.assume(tens < 10);
            vm.assume(units < 10);

            uint256 total = 100 * hundreds + 10 * tens + units;
            console2.log("total:", total);

            vm.assume(total < 49 * 10);
            vm.assume(total & 1 == 0);
            vm.assume(tens == units + 3);
            vm.assume(units != 2);
            vm.assume(units != 4);
            assertNotEq(hundreds + tens + units, 19);
        }
    }

    function abs(int256 x) internal pure returns (uint256) {
        if (x < 0) {
            return uint256(-x);
        } else {
            return uint256(x);
        }
    }

    // function test_mathHomeworkAllowNegative(int256 solution) external {
    //     uint256 units = abs(solution % 10);
    //     uint256 tens = abs((solution / 10) % 10);
    //     uint256 hundreds = abs((solution / 100) % 10);

    //     vm.assume(solution < 49 * 10);
    //     vm.assume(solution % 2 == 0);
    //     vm.assume(tens == units + 3);
    //     vm.assume(units != 2);
    //     vm.assume(units != 4);
    //     assertNotEq(hundreds + tens + units, 19);
    // }
}
