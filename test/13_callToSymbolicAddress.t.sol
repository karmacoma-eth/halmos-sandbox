// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test13 is Test {
    address constant target = address(0x42);

    function test_callToSymbolicAddress(address recipient) external {
        vm.assume(target.balance == 0);

        vm.deal(address(this), 1 ether);
        (bool succ,) = recipient.call{value: 1 ether}("");

        assertEq(target.balance, 0 ether);
    }

    function test_prankCallToSymbolicAddress(address sender, address payable recipient) external {
        vm.assume(target.balance == 0);
        vm.assume(sender != recipient);

        hoax(sender, 1 ether);
        recipient.transfer(1 ether);

        assertEq(target.balance, 0 ether);
    }
}
