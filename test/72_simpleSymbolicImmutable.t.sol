// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {console2} from "forge-std/console2.sol";

contract WithImmutable {
    address immutable target;

    constructor(address _target) {
        target = _target;
    }

    function isTarget(address other) external view returns (bool) {
        return other == target;
    }
}

contract Test71 is Test, SymTest {
    WithImmutable withImmutable;

    function setUp() public {
        address x = svm.createAddress("x");
        withImmutable = new WithImmutable(x);
    }

    function test_withConcreteImmutable() external {
        assert(!withImmutable.isTarget(address(0)));
    }

    // counterexample expected
    function test_symbolicImmutable(address y) external view {
        assert(!withImmutable.isTarget(y));
    }
}
