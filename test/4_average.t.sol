// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract TestAverage is Test {
    function averageNaive(uint256 a, uint256 b) public pure returns (uint256) {
        return (a + b) / 2;
    }

    function averageOZ(uint256 a, uint256 b) public pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /// @notice this only checks that the result is the same if both call succeed
    /// @notice would normally need to run with `--smt-div`, but the division by 2 is lowered to a shift
    function test_averageIgnoreReverts(uint256 a, uint256 b) external {
        assertEq(averageNaive(a, b), averageOZ(a, b));
    }

    function test_averageWithReverts(uint256 a, uint256 b) external {
        (bool succNaive, bytes memory resultNaive) =
            address(this).call(abi.encodeWithSignature("averageNaive(uint256,uint256)", a, b));
        (bool succOZ, bytes memory resultOZ) =
            address(this).call(abi.encodeWithSignature("averageOZ(uint256,uint256)", a, b));
        assertEq(succNaive, succOZ);
        assertEq(resultNaive, resultOZ);
    }
}
