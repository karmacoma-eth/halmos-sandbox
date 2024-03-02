// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.26;

import "forge-std/Test.sol";

contract ArrayLooper {
    function array_loop(uint256 n) external pure {
        uint8[2] memory a;
        a[0] = 100;
        for (uint8 i = 1; i < n; ++i) {
            a[i] = 100;
            assert(a[i - 1] == 100);
        }
    }
}

contract ArrayLooperTest is Test {
    ArrayLooper looper;

    function setUp() public {
        looper = new ArrayLooper();
    }

    function test_func_array_loop(uint256 n) external view {
        try looper.array_loop(n) {
            // pass
        } catch (bytes memory errordata) {
            console2.logBytes(errordata);
            assert(false);
        }
    }
}
