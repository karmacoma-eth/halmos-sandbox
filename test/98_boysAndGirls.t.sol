// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";



contract GirlsAndBoys is Test, SymTest {
    function whoStr(uint256 w) internal pure returns (string memory) {
        return w == 0 ? "boys " : "girls ";
    }

    function whatStr(uint256 w) internal pure returns (string memory) {
        return w == 0 ? "who do " : w == 1 ? "who like " : w == 2 ? "to be " : "like they're ";
    }

    function setUp() public {
        console2.log("Test98.setUp");
        console.log("looking for");
    }

    function test_boysAndGirls(uint256 who1, uint256 what1, uint256 who2, uint256 what2) external pure {
        string memory s = string(abi.encodePacked(
            whoStr(who1),
            // "who ",
            whatStr(what1),
            whoStr(who2),
            // "who ",
            whatStr(what2)
        ));
        console.log(s);
    }

}
