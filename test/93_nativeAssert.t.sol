// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract DepositBoy {
    mapping(address => uint256) public deposits;

    function deposit() public payable {
        deposits[msg.sender] += msg.value;
    }
}

contract Test93 is Test, SymTest {
    DepositBoy depositBoy;

    function setUp() public {
        depositBoy = new DepositBoy();
    }

    function test_nativeAssert(uint256 amountToDeposit) external {
        vm.deal(address(this), amountToDeposit);
        depositBoy.deposit{value: amountToDeposit}();

        assertEq(0, amountToDeposit + depositBoy.deposits(address(depositBoy)));
    }
}
