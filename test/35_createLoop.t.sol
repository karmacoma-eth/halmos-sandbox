// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract CreateLoopTest {
    function test_createLoop() public {
        // bytecode for:
        //     codecopy(0, 0, codesize())
        //     create(0, 0, codesize())
        bytes memory creationCode = hex"386000803938600080f050";
        assembly {
            let addr := create(0, add(creationCode, 0x20), mload(creationCode))
        }
    }
}
