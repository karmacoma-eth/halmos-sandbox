// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Empty {
    constructor() {
        assembly {
            return(0, 0)
        }
    }
}

contract Test85 is Test, SymTest {
    Empty e;

    function setUp() public {
        e = new Empty();
    }

    function test_extcodehash_empty() external {
        assertEq(address(e).code.length, 0, "Empty contract should have no code");

        address _e = address(e);
        bytes32 codehash;
        assembly {
            codehash := extcodehash(_e)
        }

        assertEq(codehash, keccak256(""), "Expected codehash of the empty string");
    }

    function test_extcodehash_eoa() external {
        bytes32 codehash;
        assembly {
            codehash := extcodehash(0x1337)
        }

        assertEq(codehash, 0);
    }
}
