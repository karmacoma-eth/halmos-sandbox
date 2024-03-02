// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
// import "forge-std/Test.sol";

contract Monotonic {
    function f(uint256 x) public pure returns (uint256) {
        if (x < type(uint128).max) {
            return x * 42;
        } else {
            return x;
        }
    }

    function inv(uint256 a, uint256 b) public pure {
        require(b > a);
        assert(f(b) > f(a));
    }
}
