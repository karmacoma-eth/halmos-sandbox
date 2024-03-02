// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Dummy {}

/// @notice don't use, this is very buggy on purpose
contract SmolWETH {
    function deposit() external payable {
        // bug: we stomp any existing balance
        assembly {
            sstore(caller(), callvalue())
        }
    }

    function withdraw(uint256) external {
        assembly {
            // revert if msg.value > 0
            if gt(callvalue(), 0) { revert(0, 0) }

            let amount := sload(caller())
            let success := call(gas(), caller(), amount, 0, 0, 0, 0)

            // bug: we always erase the balance, regardless of transfer success
            // bug: we should erase the balance before making the call
            sstore(caller(), 0)
        }
    }

    function balanceOf(address account) external view returns (uint256) {
        assembly {
            mstore(0, sload(account))
            return(0, 0x20)
        }
    }
}

contract SmolWETHTest is Test, SymTest {
    SmolWETH weth;

    function setUp() public {
        weth = new SmolWETH();
    }

    function test_deposit_once(address alice, uint256 amount) external {
        // fund alice
        vm.deal(alice, amount);

        // alice deposits
        vm.prank(alice);
        weth.deposit{value: amount}();

        // alice's balance is updated
        assertEq(weth.balanceOf(alice), amount);
    }

    function test_deposit_twice(address alice, uint128 amount1, uint128 amount2) external {
        uint256 totalAmount = amount1 + amount2;

        // fund alice
        vm.deal(alice, totalAmount);

        // 1st deposit
        vm.prank(alice);
        weth.deposit{value: amount1}();

        // alice's balance is updated
        assertEq(weth.balanceOf(alice), amount1);

        // 2nd deposit
        vm.prank(alice);
        weth.deposit{value: amount2}();

        assertEq(weth.balanceOf(alice), totalAmount);
    }
}
