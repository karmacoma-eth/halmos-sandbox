// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract KeccakMeditations is Test {
    // [PASS] test_keccakMeditations(uint256) (paths: 1/3, time: 0.04s, bounds: [])
    function test_keccak_collision(uint256 x, uint256 y) external pure {
        vm.assume(x != y);

        assert(keccak256(abi.encodePacked(x)) != keccak256(abi.encodePacked(y)));
    }

    // we expect this to pass, there are no counterexamples
    function prove_keccakMeditations_mixedSizes1(uint128 x, uint256 y) external pure {
        assert(keccak256(abi.encodePacked(x)) != keccak256(abi.encodePacked(y)));
    }

    // we expect this to fail, [x=0, y=0] is a counterexample
    function prove_keccakMeditations_mixedSizes2(uint128 x, uint256 y) external pure {
        assert(keccak256(abi.encodePacked(uint256(x))) != keccak256(abi.encodePacked(y)));
    }

    // we expect this to fail, [x=0, y=0] is a counterexample
    function prove_keccakMeditations_sameSizeDifferentType(int256 x, uint256 y) external pure {
        assert(keccak256(abi.encodePacked(x)) != keccak256(abi.encodePacked(y)));
    }
}
