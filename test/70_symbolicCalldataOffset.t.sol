// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test70 is Test, SymTest {
    function test_symbolicCalldataOffset(bytes calldata beep) external {
        // ✅ works, calldata offset is concrete
        console2.log("beep[42]", uint8(beep[42]));

        // ❌ fails, calldata offset is symbolic
        uint256 boop = svm.createUint256("boop");
        console2.log("offset", uint8(beep[boop]));
    }
}
