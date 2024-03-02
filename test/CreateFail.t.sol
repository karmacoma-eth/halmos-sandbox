// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract Bar {
    uint256 immutable x;

    constructor(uint256 _x) {
        assert(_x != 42);
        x = _x;
    }
}

contract Foo is Test {
    function testCreate() public {
        bytes memory creationCode = abi.encodePacked(type(Bar).creationCode, uint256(42));

        address addr;
        bytes memory returndata;

        assembly {
            addr := create(0, add(creationCode, 0x20), mload(creationCode))

            // advance free mem pointer to allocate `size` bytes
            let free_mem_ptr := mload(0x40)
            mstore(0x40, add(free_mem_ptr, returndatasize()))

            returndata := free_mem_ptr
            mstore(returndata, returndatasize())

            let offset := add(returndata, 32)
            returndatacopy(
                offset,
                0, // returndata offset
                returndatasize()
            )
        }

        assertEq(addr, address(0));
        assertEq(returndata.length, 36);
    }
}
