// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract HalmosCheckBalance is Test, SymTest {
    function setUp() public {
        console2.log("Test108.setUp");
    }

    function check_balanceToRebasingCredits(uint256 rebasingCreditsPerToken, uint256 balance) public {
        vm.assume(rebasingCreditsPerToken <= 1e27 && rebasingCreditsPerToken >= 1e18);
        vm.assume(balance <= 1e25);
        uint256 rebasingCredits = ((balance) * rebasingCreditsPerToken + 1e18 - 1) / 1e18;
        uint256 actualBalance = (rebasingCredits * 1e18) / rebasingCreditsPerToken;
        assertEq(actualBalance, balance);
    }
}
