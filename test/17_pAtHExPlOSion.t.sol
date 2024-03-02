// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

function pathy_addy(uint256 x) pure returns (bool) {
    int256 acc = 0;

    acc += (x & (0xFF << 0) > 0) ? int256(1) : int256(-1);
    acc += (x & (0xFF << 8) > 0) ? int256(-2) : int256(3);
    acc += (x & (0xFF << 16) > 0) ? int256(5) : int256(-3);
    acc += (x & (0xFF << 24) > 0) ? int256(-7) : int256(11);
    acc += (x & (0xFF << 32) > 0) ? int256(11) : int256(-7);
    acc += (x & (0xFF << 40) > 0) ? int256(-13) : int256(17);
    acc += (x & (0xFF << 48) > 0) ? int256(17) : int256(-13);
    acc += (x & (0xFF << 56) > 0) ? int256(-19) : int256(23);
    acc += (x & (0xFF << 64) > 0) ? int256(23) : int256(-19);
    acc += (x & (0xFF << 72) > 0) ? int256(-29) : int256(31);
    console2.log(uint256(acc));

    return acc > 0;
}

function pathy_muly(uint256 x) pure returns (bool) {
    uint256 acc = 1;

    // notice, all the values are primes. So the system has to figure
    // out the primal decomposition of the solution. Hence, there is a unique
    // solution (given that we cannot roll over due to low numbers)
    acc *= (x & 0xFF000000000000000000 > 0) ? uint256(1) : uint256(31);
    acc *= (x & 0x00FF0000000000000000 > 0) ? uint256(3) : uint256(37);
    acc *= (x & 0x0000FF00000000000000 > 0) ? uint256(5) : uint256(41);
    acc *= (x & 0x000000FF000000000000 > 0) ? uint256(7) : uint256(43);
    acc *= (x & 0x00000000FF0000000000 > 0) ? uint256(11) : uint256(47);
    acc *= (x & 0x0000000000FF00000000 > 0) ? uint256(13) : uint256(53);
    acc *= (x & 0x000000000000FF000000 > 0) ? uint256(17) : uint256(59);
    acc *= (x & 0x00000000000000FF0000 > 0) ? uint256(19) : uint256(61);
    acc *= (x & 0x0000000000000000FF00 > 0) ? uint256(23) : uint256(67);
    acc *= (x & 0x000000000000000000FF > 0) ? uint256(29) : uint256(71);

    // 31*3*5*7*47*13*59*19*67*71
    // = 10605495576585
    return acc != 10605495576585;
}

contract SyntheticManyBranch is Test {
    function test_pAtHExPlOSion_addy(uint256 x) external {
        assertTrue(pathy_addy(x));
    }

    function test_pAtHExPlOSion_muly(uint256 x) external {
        assertTrue(pathy_muly(x));
    }
}
