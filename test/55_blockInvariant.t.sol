// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract RemembersBlockNumber is Test {
    uint256 public blockNumber;

    constructor() {
        blockNumber = block.number;
    }

    function unchanged() external view returns (bool) {
        return blockNumber == block.number;
    }

    function cheat(uint256 newBlockNumber) external {
        vm.roll(newBlockNumber);
        update();
    }

    function update() public {
        blockNumber = block.number;
    }
}

contract Test55 is Test {
    RemembersBlockNumber mem;

    function setUp() external {
        mem = new RemembersBlockNumber();
        targetContract(address(mem));
    }

    function invariant_block_number() external {
        vm.roll(42);
        assertTrue(mem.unchanged());
    }
}
