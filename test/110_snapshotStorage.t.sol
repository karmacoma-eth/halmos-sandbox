// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Dummy {
    uint256 public x = 0;

    function set(uint256 _x) external {
        x = _x;
    }
}

/// @custom:halmos --storage-layout solidity
contract Test110 is Test, SymTest {
    Dummy dummy;

    function setUp() public {
        console2.log("Test110.setUp");
        dummy = new Dummy();
    }

    function test_snapshotStorage() external {
        uint256 snapshotBefore = svm.snapshotStorage(address(dummy));

        dummy.set(0);

        uint256 snapshotAfter = svm.snapshotStorage(address(dummy));

        // the equality check fails because there was a write to dummy's storage,
        // even if it did not result in an actually different storage
        assertEq(snapshotBefore, snapshotAfter);
    }
}
