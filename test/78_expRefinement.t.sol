// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test78 is Test {
    function test_expRefinement(uint256 x) external {
        vm.assume(x != 0);

        unchecked {
            assert(x ** 4 != 0);
        }
    }

    /// checks with abstracted evm_bvumod first, then refines with actual bvumod
    function test_modRefinement(uint256 x) external {
        vm.assume(x != 0);

        unchecked {
            assert(x % 7 != 0);
        }
    }
}
