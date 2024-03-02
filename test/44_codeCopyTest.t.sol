// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

contract CodeCopyTest is Test {
    function testCodeCopy(bytes4 sel, uint256 val, uint256 arg1) public {
        address c;

        bytes memory bytecode =
            hex"61006161000f6000396100616000f35f3560e01c60026003820660011b61005b01601e395f51565b6306661abd81186100535734610057575f5460405260206040f3610053565b63210970c5811861005357602436103417610057576004355f55005b5f5ffd5b5f80fd003700530018841861810600a16576797065728300030a0013";
        assembly {
            c := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        bytes memory cd = abi.encodePacked(sel, arg1);
        (bool sizeopt_s, bytes memory sizeopt_d) = c.call{value: val}(cd);
    }
}
