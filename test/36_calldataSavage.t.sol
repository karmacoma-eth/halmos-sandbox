// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import {console2} from "forge-std/console2.sol";

contract Dummy {}

contract Savagery is Test {
    function test_calldatacopy_large_offset() public {
        uint256 index = 1 ether;
        uint256 value;
        assembly {
            calldatacopy(0, index, 32)
            value := mload(0)
        }

        assertEq(value, 0);
    }

    function test_calldataload_large_offset() public {
        uint256 index = 1 ether;
        uint256 value;
        assembly {
            value := calldataload(index)
        }

        assertEq(value, 0);
    }

    function test_codecopy_large_offset() public {
        uint256 index = 1 ether;
        uint256 value;
        assembly {
            codecopy(0, index, 32)
            value := mload(0)
        }

        assertEq(value, 0);
    }

    function test_codecopy_offset_across_boundary() public {
        uint256 index = address(this).code.length - 16;
        uint256 value;
        assembly {
            codecopy(0, index, 32)
            value := mload(0)
        }

        assertNotEq(value, 0);
    }

    // TODO
    // function test_extcodecopy_boundary() public {
    //     address target = address(this);
    //     uint256 index = target.code.length - 16;
    //     uint256 value;
    //     assembly {
    //         extcodecopy(target, 0, index, 32)
    //         value := mload(0)
    //     }

    //     console2.log("value:", value);
    //     assertNotEq(value, 0);
    // }

    function test_returndatasize() public {
        assertEq(returndatasize(), 0);

        this.bar();
        assertEq(returndatasize(), 32);

        new Dummy();
        assertNotEq(returndatasize(), 0);
    }

    function bar() public pure returns (uint256) {
        return 1;
    }

    function returndatasize() internal pure returns (uint256 size) {
        assembly {
            size := returndatasize()
        }
    }
}
