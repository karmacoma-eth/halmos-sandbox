// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract Test51 is Test {
    uint256 constant n = 64;

    mapping(bytes32 => bool) used;

    function prove_keccakPerf() external {
        // console2.log("n =", n);
        uint256[] memory combos = new uint256[](n);

        for (uint256 i = 0; i < n;) {
            combos[i] = i;
            keccak256(abi.encode(combos));
            used[keccak256(abi.encode(combos))] = true;

            unchecked {
                ++i;
            }
        }

        assert(false);
    }
}
