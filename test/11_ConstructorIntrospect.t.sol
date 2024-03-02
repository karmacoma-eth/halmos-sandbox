// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract Dummy {
    constructor() payable {
        console2.log("address(this)", address(this));
        console2.log("codesize", address(this).code.length);
    }
}

contract Test11 is Test {
    function test_ConstructorIntrospect() external {
        Dummy d = new Dummy();
    }
}
