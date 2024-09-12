// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract GenerateAddressTest is Test {
    function hashToUint256(uint256 _id) internal pure returns (uint256) {
        return uint256(keccak256(abi.encode(_id, "offer")));
    }

    function generateOfferAddress(uint256 _id) internal pure returns (address) {
        return address(uint160(hashToUint256(_id)));
    }

    address testGeneratedAddress;
    uint256 generatedValue1;
    uint256 testNumber = 1;

    function setUp() public {
        testGeneratedAddress = generateOfferAddress(testNumber);
        generatedValue1 = hashToUint256(1);
    }

    function test_address_collision(uint256 _id) public view {
        vm.assume(_id != 1);
        address generatedAddress = generateOfferAddress(_id);
        if (testGeneratedAddress == generatedAddress) {
            console2.log("");
            console2.log("test id: ", _id);
            console2.log("test address: ", testGeneratedAddress);
            console2.log("address: ", generatedAddress);
            console2.log("");
        }

        assert(generatedAddress != testGeneratedAddress);
    }

    function to_address(uint256 x) public pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encode(x)))));
    }

    function test_uint256_collision(uint256 x, uint256 y) public {
        vm.assume(x != y);
        assertNotEq(keccak256(abi.encode(x)), keccak256(abi.encode(y)));
    }

    function test_uint160_collision(uint256 x, uint256 y) public {
        vm.assume(x != y);
        assertNotEq(
            to_address(x),
            to_address(y)
        );
    }
}
