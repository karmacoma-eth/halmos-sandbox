// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

import {SimpleDSChief} from "src/SimpleDSChief.sol";

contract Test119 is Test, SymTest {
    SimpleDSChief dschief;
    uint256 constant k = 2;

    function setUp() public {
        console2.log("Test119.setUp");
        dschief = new SimpleDSChief();
    }

    function explore() internal {
        for (uint256 i = 0; i < k; i++) {
            address sender = svm.createAddress("sender");
            vm.assume(sender != address(0));
            bytes memory data = svm.createCalldata("SimpleDSChief");

            vm.prank(sender);
            (bool success, bytes memory result) = address(dschief).call(data);
            vm.assume(success);
        }
    }

    function check_SimpleDSChief_invariant() public {
        explore();

        address sender = svm.createAddress("sender");
        vm.assume(sender != address(0));

        bytes32 senderSlate = dschief.votes(sender);
        address option = dschief.slates(senderSlate);
        uint256 senderDeposit = dschief.deposits(sender);

        assertGe(dschief.approvals(option), senderDeposit);
    }
}
