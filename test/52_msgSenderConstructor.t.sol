// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract TestContractConstructor is Test {
    event Log(uint256 x);

    // also executed in constructor
    address public dolphin = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    constructor() payable {
        console2.log("dolphin address =", dolphin);

        console2.log("address(this) =", address(this));
        console2.log("msg.sender =", msg.sender);
        console2.log("msg.value =", msg.value);
        console2.log("msg.data.length =", msg.data.length);

        console2.log("block.coinbase =", block.coinbase);
        console2.log("block.prevrandao =", block.prevrandao);
        console2.log("block.gaslimit =", block.gaslimit);
        console2.log("block.number =", block.number);
        console2.log("block.timestamp =", block.timestamp);

        console2.log("tx.origin =", tx.origin);
        console2.log("tx.gasprice =", tx.gasprice);

        // can also emit events, will be visible in the trace
        emit Log(0x42);
    }

    function test_constructor() external {}
}
