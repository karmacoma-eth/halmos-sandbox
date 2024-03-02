// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Owned {
    address public owner;
    address private ownerCandidate;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyOwnerCandidate() {
        require(msg.sender == ownerCandidate);
        _;
    }

    function transferOwnership(address candidate) external onlyOwner {
        ownerCandidate = candidate;
    }

    function acceptOwnership() external onlyOwnerCandidate {
        owner = ownerCandidate;
    }
}

contract Handler is Test {
    Owned owned;

    constructor(Owned _owned) {
        owned = _owned;
    }

    function transferOwnership(address sender, address candidate) external {
        vm.assume(sender != address(0));
        vm.prank(sender);
        owned.transferOwnership(candidate);
    }

    function acceptOwnership(address sender) external {
        vm.assume(sender != address(0));
        vm.prank(sender);
        owned.acceptOwnership();
    }
}

contract TwoStepOwnershipTestFoundry is Test {
    address owner;
    Owned owned;
    Handler handler;

    function setUp() public {
        owner = makeAddr("owner");

        vm.prank(owner);
        owned = new Owned();

        handler = new Handler(owned);
        targetContract(address(handler));

        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = Handler.transferOwnership.selector;
        selectors[1] = Handler.acceptOwnership.selector;
        targetSelector(FuzzSelector(address(handler), selectors));
    }

    function test_successful_transfer(address newOwner) public {
        handler.transferOwnership(owner, newOwner);
        handler.acceptOwnership(newOwner);

        assertEq(owned.owner(), newOwner);
    }

    function invariant_owner_never_changes_this_is_bad_lol() public returns (bool cond) {
        cond = (owned.owner() == owner);
        assertEq(owned.owner(), owner);
    }
}

contract TwoStepOwnershipTestHalmos is Test, SymTest {
    address owner;
    Owned owned;

    function setUp() public {
        owner = address(this);
        owned = new Owned();
    }

    function invariant_owner_never_changes_this_is_bad_lol() public returns (bool cond) {
        cond = (owned.owner() == owner);
        assertEq(owned.owner(), owner);
    }

    // [FAIL] check_stateful_invariant(bytes4[]) (paths: 50/60, time: 5.96s, bounds: [|selectors|=2])
    // Counterexample:
    //     halmos_data_bytes_01 = 0xaaaa0000
    //     halmos_msg_value_uint256_03 = 0x0
    //     halmos_msg_value_uint256_06 = 0x0
    //     halmos_sender_address_02 = 0xaaaa0001
    //     halmos_sender_address_05 = 0xaaaa0000
    //     p_selectors[0]_bytes4 = 0xf2fde38b00000000000000000000000000000000000000000000000000000000
    //     p_selectors[1]_bytes4 = 0x79ba509700000000000000000000000000000000000000000000000000000000
    // Symbolic test result: 0 passed; 1 failed; time: 6.09s
    function check_stateful_invariant(bytes4[] calldata selectors) public {
        for (uint256 i = 0; i < selectors.length; i++) {
            bytes memory data = svm.createBytes(32, "data");
            address sender = svm.createAddress("sender");
            vm.assume(sender != address(0));

            uint256 msg_value = svm.createUint(256, "msg_value");

            vm.deal(sender, msg_value);
            vm.prank(sender);
            (bool succ, bytes memory ret) = address(owned).call{value: msg_value}(abi.encodePacked(selectors[i], data));
            succ;
            ret; // silence warnings
        }

        invariant_owner_never_changes_this_is_bad_lol();
    }
}
