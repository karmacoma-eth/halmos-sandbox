// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test2 is Test {
    function isPowerOfTwo_slow(uint256 x) internal pure returns (bool) {
        for (uint256 i = 0; i < 256; i++) {
            if (x == uint256(1 << i)) {
                return true;
            }
        }

        return false;
    }

    function isPowerOfTwo_fast_buggy(uint256 x) internal pure returns (bool) {
        unchecked {
            return (x & (x - 1)) == 0;
        }
    }

    // expected to fail on x = 0
    // need to run with `halmos --function test_isPowerOfTwo_fast_buggy --loop 256` to find the counterexample
    function test_isPowerOfTwo_fast_buggy(uint256 x) external {
        bool slow = isPowerOfTwo_slow(x);
        bool fast = isPowerOfTwo_fast_buggy(x);

        assertEq(slow, fast);
    }

    function isPowerOfTwo_fast(uint256 x) internal pure returns (bool) {
        return x != 0 && (x & (x - 1)) == 0;
    }

    function test_isPowerOfTwo_fast_ok(uint256 x) external {
        bool slow = isPowerOfTwo_slow(x);
        bool fast = isPowerOfTwo_fast(x);

        assertEq(slow, fast);
    }
}
