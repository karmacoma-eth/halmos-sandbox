// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract TestNoSetup is Test {
    // ✅ this is fine, setup functions are optional
    function test_NoSetUp() external pure {
        assert(true);
    }
}

contract TestOneSetup is Test {
    bool setUpInvoked;

    function setUp() external /* public also works */ {
        setUpInvoked = true;
        vm.deal(address(this), 1 ether);
    }

    // ✅ works
    function test_setUp() external {
        assertTrue(setUpInvoked);
        console2.log("balance =", address(this).balance);
    }
}

contract TestOneSetupSymbolic is Test, SymTest {
    bool setUpInvoked;

    function setUpSymbolic(uint256 startingBalance) external /* public also works */ {
        setUpInvoked = true;
        vm.deal(address(this), startingBalance);
    }

    // function setUp() external /* public also works */ {
    //     setUpInvoked = true;
    //     vm.deal(address(this), svm.createUint256("startingBalance"));
    // }

    // ✅ works
    function test_setUpSymbolic() external {
        assertTrue(setUpInvoked);
        console2.log("balance =", address(this).balance);
    }
}

contract TestBadSetup is Test {
    bool setUpInvoked;

    // ❌ will not be invoked because it takes an argument
    function setUp(uint256 a) external {
        setUpInvoked = true;
    }

    // ❌ function names are case sensitive, setUp != setup
    function setup() external {
        setUpInvoked = true;
    }

    // ❌ it must be external or public
    function setUp() internal {
        setUpInvoked = true;
    }

    function test_badSetUp() external {
        assertTrue(setUpInvoked); // fails
    }
}
