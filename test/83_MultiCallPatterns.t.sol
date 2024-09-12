// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

struct Data {
    address tokenId;
    address to;
    address participant;

    uint256 amount;
    uint256 duration;
}

contract Foo {
    uint256 public counter = 0;

    function process(Data memory data) public {
        console2.log("data.to", data.to);
        counter++;
    }

    function bar() public pure {
        console2.log("bar");
    }
}

contract Test83 is Test, SymTest {
    uint256 constant MAX_CALLS = 1;
    Foo foo;

    function setUp() public {
        foo = new Foo();
    }

    function calldataFor(bytes4 selector) internal pure returns (bytes memory) {
        if (selector == Foo.process.selector) {
            Data memory data = Data({
                tokenId: svm.createAddress("tokenId"),
                to: svm.createAddress("to"),
                participant: svm.createAddress("participant"),
                amount: svm.createUint256("amount"),
                duration: svm.createUint256("duration")
            });
            bytes memory encodedData = abi.encode(data);

            return abi.encodePacked(selector, encodedData);

        // other supported selectors
        // } else if (selector == Foo.bar.selector) {
        //     return ...

        } else {
            return "";
        }
    }

    function makeCalls(uint256 n) internal {
        for (uint256 i = 0; i < n; i++) {
            bytes4 selector = svm.createBytes4("selector");
            (bool success, ) = address(foo).call(calldataFor(selector));
            vm.assume(success);
        }
    }

    function test_notArrayLoopy() external {
        makeCalls(MAX_CALLS);

        // we expect a counterexample here
        // assert(foo.counter() == MAX_CALLS);
    }
}
