// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test65 is Test {
    function doesNotRevert() public pure {}

    function reverts() public pure {
        revert("beep boop");
    }

    // This test should succeed
    function test_expectRevert_whenTargetReverts() external {
        (bool success, bytes memory returndata) = address(this).call(abi.encodeWithSignature("reverts()"));
        assertFalse(success);
        assertEq(returndata, abi.encodeWithSignature("Error(string)", "beep boop"));
    }

    // This test should fail
    function test_expectRevert_whenTargetDoesNotRevert() external {
        (bool success, bytes memory returndata) = address(this).call(abi.encodeWithSignature("doesNotRevert()"));
        assertFalse(success);
        assertEq(returndata, "beep boop");
    }

    function test_expectRevert_internalCall() external {
        vm.expectRevert("beep boop");
        reverts();
    }
}

