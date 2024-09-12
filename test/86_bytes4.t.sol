// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test86 is Test, SymTest {
    function setUp() public {
        console2.log("Test86.setUp");
    }

    function gen() public pure returns (bytes4) {
        return 0x12345678;
    }

    function test_bytes4() external {
        uint256 retdatasize;
        bytes4 val = Test86(address(this)).gen();
        assembly {
            retdatasize := returndatasize()
        }

        console2.log(uint256(uint32(val)));
        console2.log("retdatasize =", retdatasize);
    }
}
