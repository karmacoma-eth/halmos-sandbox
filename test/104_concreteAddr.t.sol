// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test104 is Test, SymTest {
    function setUp() public {
        console2.log("Test104.setUp");
    }

    function test_concreteAddr() external {
        address deployer = makeAddr("deployer");
        address player = makeAddr("player");

        // works, we know "deployer" and "player" hash to different pks
        assertNotEq(deployer, player);

        // does not work, the vm.addr() step loses track of the concrete value used to seed the address
        assertNotEq(player, address(0x0));
    }
}
