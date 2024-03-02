// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test38 is Test {
    function testFuzz_check_math(uint120 _a, uint120 _b) public {
        // @audit added unchecked here because it might help with halmos not timing out
        unchecked {
            // vm.assume(_b >= 1e27);
            uint256 shares = uint256(_a);
            uint256 index = uint256(_b);

            uint256 amount = _convertToAssets(shares, index);
            uint256 sharesNew = _divUp(amount * 1e27, index);
            assertGe(shares, sharesNew);
        }
    }

    function _divUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            z = x != 0 ? ((x - 1) / y) + 1 : 0;
        }
    }

    function _convertToAssets(uint256 shares, uint256 index) internal pure returns (uint256) {
        // @audit added unchecked here because it might help with halmos not timing out. manually confirmed that the initial params sizes can't overflow
        unchecked {
            return shares * index / 1e27;
        }
    }
}
