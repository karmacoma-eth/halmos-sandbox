// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract A {}

contract B {}

contract Test82 is Test, SymTest {
    function setUp() public {
        console2.log("Test82.setUp");
    }

    function test_DeployMapperLeak1_double_deploy() external {
        A a = new A();
        B b = new B();
        assert(address(a) != address(b));
    }

    function test_DeployMapperLeak2_deploys_nothing() external {
        vm.deal(address(this), 1 ether);
        payable(address(0xaaaa0002)).transfer(1 ether);
    }
}
