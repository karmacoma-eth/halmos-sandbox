// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test58 is Test {
    function test_blockhashes() external {
        vm.roll(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        for (uint256 i = 0; i < 255; i++) {
            console2.logBytes32(blockhash(block.number - i - 1));
        }
    }

    function test_foundry_env() external {
        console2.log("address(vm) =", address(vm));
        console2.log("block.coinbase =", block.coinbase);
        console2.log("block.difficulty =", block.difficulty);
        console2.log("block.gaslimit =", block.gaslimit);
        console2.log("block.timestamp =", block.timestamp);
        console2.log("block.number =", block.number);
    }
}
