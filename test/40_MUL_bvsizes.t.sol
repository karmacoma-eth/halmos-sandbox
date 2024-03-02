// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test40 is Test {
    function prove_MUL_08(uint8 x_yoyo, uint8 y) external {
        require(y != 0);
        assert(x_yoyo <= uint256(x_yoyo) * uint256(y));
    }

    function prove_MUL_16(uint16 x, uint16 y) external {
        require(y != 0);
        assertLe(x, uint256(x) * uint256(y));
    }

    function prove_MUL_32(uint32 x, uint32 y) external {
        require(y != 0);
        assertLe(x, uint256(x) * uint256(y));
    }

    function prove_MUL_64(uint64 x, uint64 y) external {
        require(y != 0);
        assertLe(x, uint256(x) * uint256(y));
    }

    function prove_MUL_128(uint128 x, uint128 y) external {
        require(y != 0);
        assertLe(x, uint256(x) * uint256(y));
    }
}
