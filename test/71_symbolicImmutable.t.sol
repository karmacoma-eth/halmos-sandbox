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

    function isTarget(address other) external returns (bool) {
        // console2.log("address(withImmutable).code (in isTarget)");
        // dumpcode();
        return other == target;
    }

    function dumpcode() internal {
        uint256 codelength;
        assembly {
            codelength := codesize()
        }

        bytes memory code = new bytes(codelength);
        assembly {
            codecopy(add(code, 0x20), 0, codesize())
        }
        console2.logBytes(code);
    }
}

contract Test71 is Test, SymTest {
    WithImmutable withImmutable;

    function setUp() public {
        address x = svm.createAddress("x");
        withImmutable = new WithImmutable(x);
        console2.log("type(WithImmutable).creationCode");
        console2.logBytes(type(WithImmutable).creationCode);
    }

    function test_withConcreteImmutable() external {
        assert(!withImmutable.isTarget(address(0)));
    }

    // counterexample expected
    function test_symbolicImmutable(address y) external {
        assert(!withImmutable.isTarget(y));
    }
}
