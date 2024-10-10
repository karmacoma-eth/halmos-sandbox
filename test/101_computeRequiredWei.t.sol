// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";


contract Target {
    function computeRequiredWei() public view returns (uint256) {
        uint256 a = uint256(
            keccak256(
                abi.encodePacked(
                    address(this),
                    block.chainid,
                    uint256(0xDEADBEEF)
                )
            )
        );

        uint256 b = a % 1000003;
        uint256 c = (b * 42) ^ 0xBADDCAFE;
        uint256 d = c & 0xFFFFFFFF;
        uint256 e = d * 1337 + 73;

        return e;
    }
}

// h/t https://x.com/theRaz0r/status/1843938128073314402
contract Test101 is Test, SymTest {
    Target target = Target(0xAbF38369D06006a1e137D8c00b21C99a12c008Dc);

    function setUp() public {
        vm.chainId(1);

        vm.etch(address(target), type(Target).runtimeCode);
    }


    // we expect to find this value:
    //    Counterexample:
    //    p_x_uint256_00 = 0x000000000000000000000000000000000000000000000000000003d472265bf7 (4210983066615)
    // (see https://etherscan.io/tx/0x2d0e13ff3371989ec68856f127ce6fbf36f336350586a0f9513dbb43982dd5fb)
    function check_computeRequiredWei(uint256 x) public {
        assertNotEq(x, target.computeRequiredWei());
    }
}
