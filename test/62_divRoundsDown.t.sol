
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract DivisionIsHard {
    /// @notice we expect a counterexample [y = 0, x = 1]
    function prove_divRoundsDown(uint256 x, uint256 y) external {
        assert(x / y < x);
    }

    /// @notice we expect unsat (no counterexample)
    function prove_divRoundsToZero(uint256 x, uint256 y) external {
        require(x < y);
        assert(x / y == 0);
    }
}
