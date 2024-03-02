// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract SecretHolder {
    uint256 public secretFactors;

    constructor(uint256 p, uint256 q) {
        unchecked {
            secretFactors = p * q;
        }
    }

    function guess(uint256 p, uint256 q) public view returns (bool) {
        unchecked {
            return p * q == secretFactors;
        }
    }
}

contract Test48 is Test {
    SecretHolder holder;

    function setUp() public {
        uint256 p = 0x8a2cdaa8ec06f25ba5f5c6ff6cda61497acdcccfe81474bb38009ca760e38efd;
        uint256 q = 0x36448d9858ec47558a44ee32d8929eee7a22d2a4c66a271b60b123a46cc52655;
        holder = new SecretHolder(p, q);
    }

    function test_stackSpy(uint256 p, uint256 q) external view {
        assert(!holder.guess(p, q));
    }
}
