// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "forge-std/Test.sol";

contract Collatz is Test {
    function collatz(uint n) public pure returns (uint256) {
        require(n > 0);

        while (n != 1) {
            n = 
                (n % 2 == 0) 
                    ? n / 2 
                    : 3 * n + 1;
        }

        return n;
    }

    function test_collatz_equalsOne(uint256 n) public {
        vm.assume(n != 0);
        assert(collatz(n) == 1);
    }
}
