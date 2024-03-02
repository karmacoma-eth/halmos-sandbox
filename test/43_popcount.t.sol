// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

/// @custom:halmos --loop 256 --storage-layout=generic --solver-timeout-assertion=0 --statistics
contract PopcountStorageTest is Test {
    // assume we have infinite money so let's just put this in storage
    uint8[256] public pop8 = [
        0,
        1,
        1,
        2,
        1,
        2,
        2,
        3,
        1,
        2,
        2,
        3,
        2,
        3,
        3,
        4,
        1,
        2,
        2,
        3,
        2,
        3,
        3,
        4,
        2,
        3,
        3,
        4,
        3,
        4,
        4,
        5,
        1,
        2,
        2,
        3,
        2,
        3,
        3,
        4,
        2,
        3,
        3,
        4,
        3,
        4,
        4,
        5,
        2,
        3,
        3,
        4,
        3,
        4,
        4,
        5,
        3,
        4,
        4,
        5,
        4,
        5,
        5,
        6,
        1,
        2,
        2,
        3,
        2,
        3,
        3,
        4,
        2,
        3,
        3,
        4,
        3,
        4,
        4,
        5,
        2,
        3,
        3,
        4,
        3,
        4,
        4,
        5,
        3,
        4,
        4,
        5,
        4,
        5,
        5,
        6,
        2,
        3,
        3,
        4,
        3,
        4,
        4,
        5,
        3,
        4,
        4,
        5,
        4,
        5,
        5,
        6,
        3,
        4,
        4,
        5,
        4,
        5,
        5,
        6,
        4,
        5,
        5,
        6,
        5,
        6,
        6,
        7,
        1,
        2,
        2,
        3,
        2,
        3,
        3,
        4,
        2,
        3,
        3,
        4,
        3,
        4,
        4,
        5,
        2,
        3,
        3,
        4,
        3,
        4,
        4,
        5,
        3,
        4,
        4,
        5,
        4,
        5,
        5,
        6,
        2,
        3,
        3,
        4,
        3,
        4,
        4,
        5,
        4,
        4,
        4,
        5,
        4,
        5,
        5,
        7, // <-- bug, last number should be 6
        3,
        4,
        4,
        5,
        4,
        5,
        5,
        6,
        4,
        5,
        5,
        6,
        5,
        6,
        6,
        7,
        2,
        3,
        3,
        4,
        3,
        4,
        4,
        5,
        3,
        4,
        4,
        5,
        4,
        5,
        5,
        6,
        3,
        4,
        4,
        5,
        4,
        5,
        5,
        6,
        4,
        5,
        5,
        6,
        5,
        6,
        6,
        7,
        3,
        4,
        4,
        5,
        4,
        5,
        5,
        6,
        4,
        5,
        5,
        6,
        5,
        6,
        6,
        7,
        4,
        5,
        5,
        6,
        5,
        6,
        6,
        7,
        5,
        6,
        6,
        7,
        6,
        7,
        7,
        8
    ];

    function popcount_buggy(uint256 x) public view returns (uint256) {
        uint256 c = 0;
        for (uint8 i = 0; i < 32; i++) {
            c += pop8[x & 0xff];
            x >>= 8;
        }
        return c;
    }

    function popcount_slow(uint256 x) public pure returns (uint256) {
        uint256 c = 0;
        for (uint256 i = 0; i < 256; i++) {
            c += x & 1;
            x >>= 1;
        }
        return c;
    }

    function popcount_buggy_byte(uint8 x) public view returns (uint8) {
        return pop8[x];
    }

    function popcount_slow_byte(uint8 x) public pure returns (uint8) {
        uint8 c = 0;
        for (uint8 i = 0; i < 8; i++) {
            c += x & 1;
            x >>= 1;
        }
        return c;
    }

    function test_popcount_sanity() public {
        assertEq(popcount_buggy(0), 0);
        assertEq(popcount_buggy(1), 1);

        assertEq(this.popcount_slow(0), 0);
        assertEq(this.popcount_slow(1), 1);
    }

    // for hevm
    function prove_popcount_equiv(uint256 x) public {
        assertEq(popcount_buggy(x), popcount_slow(x));
    }

    // for hevm
    function prove_popcount_equiv_byte(uint8 x) public {
        assertEq(popcount_buggy_byte(x), popcount_slow_byte(x));
    }

    // for foundry
    function testFuzz_popcount_equiv(uint256 x) public {
        prove_popcount_equiv(x);
    }

    // for foundry
    function testFuzz_popcount_equiv_byte(uint8 x) public {
        prove_popcount_equiv(x);
    }

    function test_validate_counterexample() public {
        uint256 cex = 0x00000000000000000000000000000000000000000000000000000000000000c0;

        uint256 buggy_result = popcount_buggy(cex);
        uint256 expected_result = popcount_slow(cex);
        console2.log(buggy_result);
        console2.log(expected_result);
        assertEq(buggy_result, expected_result);
    }
}
