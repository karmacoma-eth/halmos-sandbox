// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {console2} from "forge-std/console2.sol";

contract TestTypeRendering is Test, SymTest {
    function test_int8(int8 x) public {
        assertGe(x, 0);
    }

    function test_uint8(uint8 x) public {
        assertGe(x, 0);
    }

    function test_very_small_int256(int256 x) public {
        require(x < 0);
        assertGe(x, -2 ** 128);
    }

    function test_very_large_int256(int256 x) public {
        assertLe(x, 2 ** 128);
    }

    function test_dirty_int8(uint256 x) public {
        (bool succ,) = address(this).call(abi.encodeWithSignature("test_int8(int8)", x));
        assertTrue(succ);
    }

    function test_dirty_uint8(uint256 x) public {
        (bool succ,) = address(this).call(abi.encodeWithSignature("test_uint8(uint8)", x));
        assertTrue(succ);
    }

    function test_bytes32(bytes32 x) public {
        assertEq(x, keccak256("hello"));
    }

    function test_bool_true(bool x) public {
        assertFalse(x);
    }

    function test_bool_false(bool x) public {
        assertTrue(x);
    }

    /// @custom:halmos --loop 5
    function test_dynamic_bytes() public {
        bytes memory m = svm.createBytes(5, "m");
        assertEq(m.length, 5);
        console2.logBytes(m);
        assertNotEq0(m, "hello");
    }

    function test_string() public {
        string memory expected = string("hello");
        string memory s = string(svm.createBytes(5, "some_string"));
        assertNotEq(s, expected);
    }

    function test_address(address x) public {
        assertEq(x, address(this));
    }
}
