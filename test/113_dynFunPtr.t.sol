// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";


contract ContractTest is Test, SymTest {

    A a;

    function setUp() public {
    }

    function check_deploy() public {
        uint256 x = svm.createUint256("offset");
        /*
        vm.assume(x > (1 << 0x20));
        vm.assume(x < (1 << 0x30));
        */
        bytes memory y = hex"5b6e66737563636573735f5260205fa000600052600f6011f3";
        /*
        JUMPDEST PUSH15 0x66737563636573735f5260205fa000 PUSH1 0x00 MSTORE PUSH1 0x20 PUSH1 0x00 RETURN
        */
        /*
        PUSH7 0x73756363657373 PUSH0 MSTORE PUSH1 0x20 PUSH0 LOG0 STOP // return a log with "success"
        */

        // This success with the hardcoded x value : (0x257 << 0x20)
        // test_bytecode();

        // Halmos should be able to find the x offset, but does not for the moment :

        /*
        (bool s,) =  address(this).call(abi.encodeWithSignature("deploy_A(uint256,bytes)", x, y));
        assert(!s);
        */

        // OR

        a = new A(x,y);
        bytes memory expectedCode = hex"66737563636573735f5260205fa000";
        assert(keccak256(address(a).code) != keccak256(expectedCode));

    }

    function deploy_A(uint256 x, bytes memory y) public {
        a = new A(x,y);
    }

    function test_bytecode() public {
        uint256 x = (0x257 << 0x20);
        bytes memory y = hex"5b6e66737563636573735f5260205fa000600052600f6011f3";
        // bytes memory bytecode = abi.encodePacked(type(A).creationCode, abi.encode(x, y));

        a = new A(x,y);

        // check the code is well deployed
        bytes memory expectedCode = hex"66737563636573735f5260205fa000";
        assert(keccak256(address(a).code) == keccak256(expectedCode));
    }
}

contract A {
    // events
    event Success();

    constructor(uint256 x, bytes memory y) {
        function() internal foo;
        assembly {
            foo := x
        }
        foo();
    }

    // public so that it's not eliminated by the optimizer
    function bar() public {
        emit Success();
    }
}
