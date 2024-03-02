// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test54 is Test {
    uint256 constant WAD = 1e18;

    function fromWAD(uint256 a) public pure returns (uint256 c) {
        c = a / WAD;
    }

    function toWAD(uint256 a) public pure returns (uint256 c) {
        c = a * WAD;
    }

    function test_fromWAD_DONT(uint256 a) external {
        uint256 b = 0;
        unchecked {
            console2.log("val =", uint256(42 / b));
        }

        vm.assume(a < type(uint256).max / WAD);
        assertEq(fromWAD(toWAD(a)), a);
    }
}
