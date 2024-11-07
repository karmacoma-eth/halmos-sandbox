// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

error CustomError(uint256 code);

contract CallMe {
    function revertsWithStaticErrorString() public pure {
        revert("revertsWithStaticErrorString");
    }

    function revertsWithDynamicErrorString(string memory errString) public pure {
        revert(errString);
    }

    function revertsWithStaticCustomError() public pure {
        revert CustomError(42);
    }

    function revertsWithDynamicCustomError(uint256 code) public pure {
        revert CustomError(code);
    }
}

contract Test106 is Test, SymTest {
    CallMe cm;

    function setUp() public {
        cm = new CallMe();
    }

    function test_revertsWithStaticErrorString() external view {
        // 👍 this is the preferred pattern
        // high level string error messages can be caught directly
        try cm.revertsWithStaticErrorString() {
            assertTrue(false, "expected revert");
        } catch Error(string memory reason) {
            assertEq(reason, "revertsWithStaticErrorString");
        }

        // 👎 not as nice
        // but you can also catch error strings with the low level bytes
        try cm.revertsWithStaticErrorString() {
            assertTrue(false, "expected revert");
        } catch (bytes memory reason) {
            assertEq(reason, abi.encodeWithSignature("Error(string)", "revertsWithStaticErrorString"));
        }
    }

    // ❌ don't do this, it doesn't work
    function testFail_revertsWithStaticCustomError() external view {
        try cm.revertsWithStaticCustomError() {
            assertTrue(false, "expected revert");
        } catch Error(string memory reason) {
            // this block is not going to execute, since a custom error is raised rather than an error string
            // the CustomError(42) revert will bubble up and the test will fail
        }
    }

    function test_revertsWithStaticCustomError() external view {
        bytes memory expected = abi.encodeWithSignature("CustomError(uint256)", 42);
        // 👍
        try cm.revertsWithStaticCustomError() {
            assertTrue(false, "expected revert");
        } catch (bytes memory actual) {
            assertEq(actual, expected);
        }

        // 👎 works but no need for keccak256
        try cm.revertsWithStaticCustomError() {
            assertTrue(false, "expected revert");
        } catch (bytes memory actual) {
            assertEq(keccak256(actual), keccak256(expected));
        }
    }
}
