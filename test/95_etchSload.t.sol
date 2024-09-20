// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract NotEtchFriendly {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function beepBoop() public {
        console2.log("owner is", owner);
        require(msg.sender == owner, "NotEtchFriendly: only owner can beep boop");
    }
}

contract Test95 is Test, SymTest {
    NotEtchFriendly target;

    function setUp() public {
        /// @dev this is supported in foundry, but not halmos (can't vm.store to uninitialized account)
        // make address(this) the owner of the yet-to-be-deployed contract
        // vm.store(address(42), 0, bytes32(uint256(uint160(address(this)))));

        // etch does not run the constructor, so owner is not set by the constructor
        // additionally, vm.etch does not reset storage (unlike CREATE2)
        vm.etch(address(42), type(NotEtchFriendly).runtimeCode);

        target = NotEtchFriendly(address(42));
    }

    function check_etch_no_owner(address sender) external {
        vm.prank(sender);
        target.beepBoop();

        // the constructor did not run, but the SLOAD works and returns address(0)
        assertEq(sender, address(0));
    }

    function check_etch_then_store() external {
        // make address(this) the owner of the contract, emulating the constructor
        vm.store(address(42), 0, bytes20(address(this)));

        target.beepBoop();
    }
}
