// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract Test19 is Test {
    function outOfBoundsCalldata(address[] calldata recipients) public pure {
        for (uint256 i = 0; i <= recipients.length; i++) {
            console2.log(recipients[i]);
        }
    }

    function outOfBoundsMemory(address[] memory recipients) public pure {
        for (uint256 i = 0; i <= recipients.length; i++) {
            console2.log(recipients[i]);
        }
    }

    function test_outOfBoundsCalldata() external view {
        Test19(address(this)).outOfBoundsCalldata(new address[](0));
    }

    function test_outOfBoundsMemory(address[] calldata) external view {
        Test19(address(this)).outOfBoundsMemory(new address[](0));
    }
}
