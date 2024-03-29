// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test69 is Test {
    uint256 alwaysZero;

    function test_fastResult(uint256 x) external pure {
        assert(x * 0 == 0);
    }

    function alwaysReverts(uint256 x) public view {
        require(alwaysZero != 0);
    }

    function test_alwaysReverts(uint256 x) external {
        (bool succ,) = address(this).staticcall(abi.encodeWithSignature("alwaysReverts(uint256)", x));
        assert(!succ);
    }
}


