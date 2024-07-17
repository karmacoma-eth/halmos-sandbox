// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Thing {
    function doThing() public pure {
        console2.log("doink!");
    }
}

contract ThingCaller {
    function callThing(Thing thing) public pure {
        thing.doThing();
    }
}

contract ThingDeployer {
    function deployThing() public returns (Thing) {
        return new Thing();
    }
}

contract Test80 is Test, SymTest {
    function setUp() public {

    }

    function test_simpleContext() external {
        ThingDeployer deployer = new ThingDeployer();
        Thing thing = deployer.deployThing();
        ThingCaller caller = new ThingCaller();
        caller.callThing(thing);
    }
}
