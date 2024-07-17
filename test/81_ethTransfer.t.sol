// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test81 is Test, SymTest {
    function check_testEth(address sender, uint256 amount) public {
        vm.assume(sender != address(0));
        vm.deal(sender, amount);
        // next line duplicates default behaviour, right?
        vm.deal(address(123), svm.createUint256("amount"));
        // vm.deal (address ( 123), 0);
        uint256 ethBefore = address(123).balance;
        vm.prank(sender);
        payable(address(123)).transfer(amount);
        uint256 ethAfter = address(123).balance;
        assert(ethAfter == ethBefore + amount);
    }
}
