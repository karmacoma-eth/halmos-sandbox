// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract ManyNames {
    string[] public names;

    constructor() {
        names.push("Alice");
        names.push("Bob");
        names.push("Charlie");
        names.push("David");
        names.push("Eve");
        names.push("Frank");
        names.push("Grace");
    }
}

contract Test79 is Test, SymTest {
    ManyNames public manyNames;

    function setUp() public {
        manyNames = new ManyNames();
    }

    function loopy(bytes memory data) public {
        uint256 i = 0;
        while (i < data.length) {
            console2.log(i);
            i++;
        }
    }

    /// prints 0..99 regardless of `--loop` bound
    function test_loopBound_internal() external {
        bytes memory data = svm.createBytes(100, "data");

        uint256 i = 0;
        while (i < data.length) {
            console2.log(i);
            i++;
        }
    }

    function test_loopBound_external() external {
        bytes memory data = svm.createBytes(100, "data");
        this.loopy(data);
    }

    function test_loopBound_fromExternalContract() external {
        uint256 i = 0;
        while (true) {
            string memory name = manyNames.names(i);
            if (bytes(name).length == 0) {
                break;
            }

            console2.log(name);
            i++;
        }
    }


    function check_Math_binarySearch (uint256 [] memory array, uint256 value) public {
        console2.log("array length", array.length);
    }
}
