// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

// // from https://docs.soliditylang.org/en/latest/types.html#function-types
// library ArrayUtils {
//     // internal functions can be used in internal library functions because
//     // they will be part of the same code context
//     function map(uint[] memory self, function (uint) pure returns (uint) f)
//         internal
//         pure
//         returns (uint[] memory r)
//     {
//         r = new uint[](self.length);
//         for (uint i = 0; i < self.length; i++) {
//             r[i] = f(self[i]);
//         }
//     }

//     function reduce(
//         uint[] memory self,
//         function (uint, uint) pure returns (uint) f
//     )
//         internal
//         pure
//         returns (uint r)
//     {
//         r = self[0];
//         for (uint i = 1; i < self.length; i++) {
//             r = f(r, self[i]);
//         }
//     }

//     function range(uint length) internal pure returns (uint[] memory r) {
//         r = new uint[](length);
//         for (uint i = 0; i < r.length; i++) {
//             r[i] = i;
//         }
//     }
// }


// contract Pyramid {
//     using ArrayUtils for *;

//     function (uint) pure returns (uint) internal pointer;

//     constructor() {
//         pointer = square;
//     }

//     function pyramid(uint l) public pure returns (uint) {
//         return ArrayUtils.range(l).map(square).reduce(sum);
//     }

//     function square(uint x) internal pure returns (uint) {
//         return x * x;
//     }

//     function sum(uint x, uint y) internal pure returns (uint) {
//         return x + y;
//     }
// }

contract TestPyramid {
    function (uint) pure returns (uint) internal pointer;
    event LogUint(uint256, uint256 control);

    function setUp() public {
        pointer = beepboop;

        uint256 pointerValue;
        assembly {
            pointerValue := sload(pointer.slot)
        }

        emit LogUint(pointerValue, 0xaabbccdd);
    }

    function beepboop(uint256 x) public pure returns (uint256) {
        return x * x;
    }

    function test_pyramid() external view {
        assert(pointer(3) == 9);
    }
}
