// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test33 is Test {
    function test_emptyDeployCode() external {
        assembly {
            // mstore(0, x)
            let addr := create(0, 0, 0)
        }
    }

    function test_emptyRuntimeCode() external {
        assembly {
            // mstore(0, x)
            let addr := create(0, 0, 0)
        }
    }
}
