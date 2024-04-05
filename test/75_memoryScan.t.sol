// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

library Memory { 
    uint256 constant FREE_MEMORY = 0x40;
    uint256 constant ZERO_SLOT = 0x60;
    uint256 constant NOT_FOUND = type(uint256).max;

    function get(uint256 pointer) internal returns (uint256 val) {
        assembly {
            val := mload(pointer)
        }
    }

    function set(uint256 pointer, uint256 val) internal {
        assembly {
            mstore(pointer, val)
        }
    }

    function freeMemoryPointer() internal returns (uint256 pointer) {
        return get(FREE_MEMORY);
    }

    // look for value `val` anywhere in memory, 
    // scanning backwards from the free memory pointer
    function scan(uint256 val) internal returns (uint256 pointer) {
        // checked math: fail if freeMemoryPointer() < 32 
        pointer = freeMemoryPointer() - 32;

        while (pointer != NOT_FOUND) {
            if (get(pointer) == val) {
                return pointer;
            }

            // we want the pointer to underflow to NOT_FOUND, which breaks the loop
            unchecked {
                pointer--;
            }
        }
    }
}

contract Test75 is Test {
    function test_scan_someValueNotFound() external {
        address dolphinAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
        assert(Memory.scan(uint256(uint160(dolphinAddress))) == Memory.NOT_FOUND);
    }

    function test_scan_someValueInAbiEncoding() external {
        address dolphinAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

        // put the value in memory
        bytes memory someBytes = abi.encode(dolphinAddress, "a bunch of bytes");

        // test that we can find it
        uint256 pointer = Memory.scan(uint160(dolphinAddress));
        assertNotEq(pointer, Memory.NOT_FOUND);

        console.log("dolphin address found at", pointer);

        // test that we can patch the value
        address sirenAddress = 0xee00ee00ee00eE00Ee00eE00ee00EE00eE00EE00;
        Memory.set(pointer, uint160(sirenAddress));

        (address decodedAddr, ) = abi.decode(someBytes, (address, string));
        assertEq(decodedAddr, sirenAddress);
    }
}
