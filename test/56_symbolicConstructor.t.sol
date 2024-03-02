// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract TestSymbolicConstructor is Test {
    uint256 deploymentBlockNumber = block.number;
    bool isOdd;

    constructor() {
        // this works:
        isOdd = block.number % 2 == 1;

        // but this doesn't:
        // if (block.number % 2 == 1) {
        //     isOdd = true;
        // } else {
        //     isOdd = false;
        // }
    }

    function check_symbolicConstructor() external {
        console2.log("isOdd =", isOdd);
        console2.log("block.number =", block.number);
    }
}
