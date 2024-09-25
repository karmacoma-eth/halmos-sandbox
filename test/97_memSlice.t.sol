// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract DumDum {}

contract Test97 is Test, SymTest {
    DumDum d;

    function setUp() public {
        console2.log("Test97.setUp");
        d = new DumDum();
    }

    function slice(bytes memory src, uint256 from, uint256 to) internal pure returns (bytes memory) {
        require(from <= to, "slice: invalid range");
        require(to <= src.length, "slice: out of bounds");

        uint256 len = to - from;
        bytes memory dst = new bytes(len);

        assembly {
            let srcOffset := add(src, 32)
            let dstOffset := add(dst, 32)
            mcopy(dstOffset, add(srcOffset, from), len)
        }

        return dst;
    }

    function invariant_memSlice() external {
        vm.assume(msg.sender == address(0));
        string memory s = "hello, world";

        assertEq(string(slice(bytes(s), 0, 0)), "");
        assertEq(string(slice(bytes(s), 0, 1)), "h");
        assertEq(string(slice(bytes(s), 1, 1)), "");
        assertEq(string(slice(bytes(s), 0, 5)), "hello");
        assertEq(string(slice(bytes(s), 7, 12)), "world");
    }
}
